//
//  RhymeFinder.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 5/13/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

class RhymeFinder{

    let DEBUGGING = true;
    var anchors = [Word]();
    var dictionary = [WordName : String]();
    var trie = PhonemicSearchTrie();
    
    let SAME_VOWEL = 5.0;
    let DIFFERENT_VOWEL = 1.0;
    let SAME_CONSONANT = 1.0;
    let DIFFERENT_CONSONANT = 0.5;
    
    init(pathToDict: String) {
        
        buildWords(pathToDict);
        
    }
    
    func buildWords(pathToDict: String){ //builds the list of Word objects that can be compared to one another
        debugPrint("starting");
        let start = NSDate();
        
        let stringData = try! String(contentsOfFile: pathToDict, encoding: NSASCIIStringEncoding)
        let lines = stringData.componentsSeparatedByString("\n").filter { !$0.hasPrefix(";;;") && !$0.isEmpty }
        
        for line in lines{
        
            let components = line.componentsSeparatedByString("  ")
            guard components.count == 2 else {
                print("The lines aren't separated by two spaces.");
                break;
            }
            
            var wordName = WordName(wordName: components[0].lowercaseString);
            
            dictionary[wordName] = components[1];
            
            let word = Word(wordName: wordName, phonemeString: components[1]);
            
            trie.addWord(word!);
        
        }
        
        let dictionaryCreationStart = NSDate();
        
        print("Dictionary created in \(NSDate().timeIntervalSince1970 - dictionaryCreationStart.timeIntervalSince1970) seconds.");
        
        print("buildWords done in \(NSDate().timeIntervalSince1970 - start.timeIntervalSince1970) seconds.");
        
    }
    
    func findRhymeValueAndPercentileForWords(anchor: Word, satellite: Word) -> Double{
        
        var rhymePercentile = 0.0;
        
        if(anchor.listOfSyllables.count == satellite.listOfSyllables.count){
            
            debugPrint("Regular Rhyme Value");
            rhymePercentile = regularRhymeValueBetweenWords(anchor, satellite: satellite);
            
        }else{
            
            debugPrint("Ideal Rhyme Value");
            rhymePercentile = idealRhymeValueBetweenWords(anchor, satellite: satellite);
            
        }
        
        return rhymePercentile;
        
    }
    
    func regularRhymeValueBetweenWords(anchor: Word, satellite: Word) -> Double{
        
        var rhymeValue = 0.0;
        
        let weightTowardsWordEnd = 0.5;
        
        
            
        var counter = 0;
        for anchorSyllable in anchor.listOfSyllables{
            
            rhymeValue = rhymeValue + findRVBetweenSyllables(anchorSyllable,
                                                            s2: satellite.listOfSyllables[counter], addWeight: true, weight: Double(counter)*weightTowardsWordEnd);
            
            counter = counter + 1;
            
        }
    
        return findRhymePercentile(rhymeValue, longerWord: anchor);
        
    }
    
    func idealRhymeValueBetweenWords(anchor: Word, satellite: Word) -> Double{
        
        var shorterWord = Word();
        var longerWord = Word();
        
        if(anchor.listOfSyllables.count < satellite.listOfSyllables.count){
            
            shorterWord = anchor;
            longerWord = satellite;
            
        }else{
            
            shorterWord = satellite;
            longerWord = anchor;
            
        }
        
        var idealRhymeValue = 0.0;
        
        var firstSearch = true;
        var foundStartingIndex = false;
        var layers = [Layer]();
        var nodesForThisLayer = [Node]();
        
        var pastLayerNumber = 0;
        
        var s = 0;
        for shorterWordSyllable in shorterWord.listOfSyllables{
            
            let weightTowardsWordEnd = 0.5;
            
            if(firstSearch == true){
                
                let startNode = Node();
                
                var l = 0;
                
                for longerWordSyllable in longerWord.listOfSyllables{
                    
                    let RVBetweenSyllables = findRVBetweenSyllables(shorterWordSyllable, s2: longerWordSyllable, addWeight: true, weight: Double(l)*weightTowardsWordEnd);
                    
                    if(RVBetweenSyllables > 0){
                        
                        foundStartingIndex = true;
                        
                        let indexSet = IndexSet(index: l, RVBetweenPhonemes: RVBetweenSyllables);
                        
                        startNode.addIndexSet(indexSet);
                        
                    }
                    
                    l = l + 1;
                    
                }
                
                if(foundStartingIndex == true){
                    
                    nodesForThisLayer.append(startNode);
                    layers.append(Layer(nodes: nodesForThisLayer));
                    firstSearch = false;
                    
                }
                
                nodesForThisLayer = [Node]();
                
            }else{
                
                for nodeBeingExamined in layers[pastLayerNumber].nodes{
                    
                    for setBeingExamined in nodeBeingExamined.indexSets{
                        
                        let childNode = Node();
                        let indexToStartAt = setBeingExamined.indexes[0];
                        
                        if(indexToStartAt + 1 == longerWord.listOfSyllables.count){
                            
                            //do nothing
                            
                        }else{
                            
                            
                            for(var l = indexToStartAt+1; l < longerWord.listOfPhonemes.count; l = l + 1){
                                
                                let RVBetweenSyllables = findRVBetweenSyllables(shorterWordSyllable, s2: longerWord.listOfSyllables[l], addWeight: true, weight: Double(l)*weightTowardsWordEnd);
                                
                                if(RVBetweenSyllables > 0){
                                    
                                    let indexSet = IndexSet(index: l, RVBetweenPhonemes: RVBetweenSyllables);
                                    childNode.addIndexSet(indexSet);
                                    
                                }
                                
                                
                            }
                            
                            setBeingExamined.attachChildNode(childNode);
                            nodesForThisLayer.append(childNode);
                            
                        }
                        
                    }
                    
                }
                
                layers.append(Layer(nodes: nodesForThisLayer));
                nodesForThisLayer = [Node]();
                
                pastLayerNumber = pastLayerNumber + 1;
                
            }
            
            s = s + 1;
            
        }
        
        //find best path
        
        var bestSet = IndexSet(index: 0, RVBetweenPhonemes: 0.0);
        var theNode = Node();
        
        var l = layers.count - 1;
        for layer in layers.reverse(){
            
            for nodeBeingExamined in layer.nodes{
                
                theNode = nodeBeingExamined;
                if(nodeBeingExamined.indexSets.count > 0){
                    
                    nodeBeingExamined.findBestIndexSetAndSendItUp();
                    
                }
                
            }
            
            if(l == 0 && layer.nodes.count == 1){
                
                bestSet = theNode.bestSet!;
                
            }
            
            l = l - 1;
            
        }
        
        idealRhymeValue = bestSet.rhymeValueForSet;
        print("Ideal Rhyme Value: ", idealRhymeValue);
        
        var rhymeValue = idealRhymeValue;
        print("Deduction: ", findDeductionForWordIndexSet(bestSet, longerWord: longerWord));
        
        rhymeValue = rhymeValue - findDeductionForWordIndexSet(bestSet, longerWord: longerWord);
        print("Rhyme Value: ", rhymeValue);
        
        return findRhymePercentile(rhymeValue, longerWord: longerWord);
        
    }
    
    func findRhymePercentile(rhymeValue: Double, longerWord: Word) -> Double{
        
        var homophonicRhymeValue = 0.0;
        var rhymePercentile = 0.0;
        
        let weightTowardsWordEnd = 0.5;
        
        var i = 0;
        for longerWordSyllable in longerWord.listOfSyllables{
            
            homophonicRhymeValue = homophonicRhymeValue + findRVBetweenSyllables(longerWordSyllable, s2: longerWordSyllable, addWeight: true, weight: Double(i)*weightTowardsWordEnd);
            
            i = i + 1;
            
        }
        
        rhymePercentile = rhymeValue / homophonicRhymeValue;
        
        return rhymePercentile;
        
    }
    
    func findRVBetweenSyllables(s1: Syllable, s2: Syllable, addWeight: Bool, weight: Double) -> Double{
        
        var rhymeValue = 0.0;
        
        if s1.listOfPhonemes.count == s2.listOfPhonemes.count {
            
            rhymeValue = regularRhymeValueBetweenSyllables(s1, s2: s2);
            
        }else{
        
            rhymeValue = idealRhymeValueBetweenSyllables(s1, satelliteSyllable: s2);
        
        }
        
        return rhymeValue + weight;
        
    }
    
    func regularRhymeValueBetweenSyllables(s1: Syllable, s2: Syllable) -> Double {
        
        var rhymeValue = 0.0;
        
        for (p, phoneme) in s1.listOfPhonemes.enumerate() {
            
            rhymeValue = rhymeValue + findRVBetweenPhonemes(s1.listOfPhonemes[p], p2: s2.listOfPhonemes[p]);
            
        }
        
        return rhymeValue;
        
    }
    
    func idealRhymeValueBetweenSyllables(anchorSyllable: Syllable, satelliteSyllable: Syllable) -> Double {
        
        var shorterSyllable = Syllable();
        var longerSyllable = Syllable();
        
        if(anchorSyllable.listOfPhonemes.count < satelliteSyllable.listOfPhonemes.count){
            
            shorterSyllable = anchorSyllable;
            longerSyllable = satelliteSyllable;
            
        }else{
            
            shorterSyllable = satelliteSyllable;
            longerSyllable = anchorSyllable;
            
        }
        
        var idealRhymeValue = 0.0;
        
        var firstSearch = true;
        var foundStartingIndex = false;
        var layers = [Layer]();
        var nodesForThisLayer = [Node]();
        
        var pastLayerNumber = 0;
        
        var s = 0;
        for shorterWordPhoneme in shorterSyllable.listOfPhonemes{
            
            let weightTowardsWordEnd = 0.1;
            
            if(firstSearch == true){
                
                let startNode = Node();
                
                var l = 0;
                
                for longerWordPhoneme in longerSyllable.listOfPhonemes{
                    
                    let RVBetweenPhonemes = findRVBetweenPhonemes(shorterWordPhoneme, p2: longerWordPhoneme);
                    
                    if(RVBetweenPhonemes > 0){
                        
                        foundStartingIndex = true;
                        
                        let indexSet = IndexSet(index: l, RVBetweenPhonemes: RVBetweenPhonemes);
                        
                        startNode.addIndexSet(indexSet);
                        
                    }
                    
                    l = l + 1;
                    
                }
                
                if(foundStartingIndex == true){
                    
                    nodesForThisLayer.append(startNode);
                    layers.append(Layer(nodes: nodesForThisLayer));
                    firstSearch = false;
                    
                }
                
                nodesForThisLayer = [Node]();
                
            }else{
                
                for nodeBeingExamined in layers[pastLayerNumber].nodes{
                    
                    for setBeingExamined in nodeBeingExamined.indexSets{
                        
                        let childNode = Node();
                        let indexToStartAt = setBeingExamined.indexes[0];
                        
                        if(indexToStartAt + 1 == longerSyllable.listOfPhonemes.count){
                            
                            //do nothing
                            
                        }else{
                            
                            
                            for(var l = indexToStartAt+1; l < longerSyllable.listOfPhonemes.count; l = l + 1){
                                //for l in indextTOStartAt+1 < longerWord.listOfPhonemes.count
                                let longerWordPhoneme = longerSyllable.listOfPhonemes[l];
                                let RVBetweenPhonemes = findRVBetweenPhonemes(shorterWordPhoneme, p2: longerWordPhoneme);
                                
                                if(RVBetweenPhonemes > 0){
                                    
                                    let indexSet = IndexSet(index: l, RVBetweenPhonemes: RVBetweenPhonemes);
                                    childNode.addIndexSet(indexSet);
                                    
                                }
                                
                                
                            }
                            
                            setBeingExamined.attachChildNode(childNode);
                            nodesForThisLayer.append(childNode);
                            
                        }
                        
                    }
                    
                }
                
                layers.append(Layer(nodes: nodesForThisLayer));
                nodesForThisLayer = [Node]();
                
                pastLayerNumber = pastLayerNumber + 1;
                
            }
            
            s = s + 1;
            
        }
        
        //find best path
        
        var bestSet = IndexSet(index: 0, RVBetweenPhonemes: 0.0);
        var theNode = Node();
        
        var l = layers.count - 1;
        for layer in layers.reverse(){
            
            for nodeBeingExamined in layer.nodes{
                
                theNode = nodeBeingExamined;
                if(nodeBeingExamined.indexSets.count > 0){
                    
                    nodeBeingExamined.findBestIndexSetAndSendItUp();
                    
                }
                
            }
            
            if(l == 0 && layer.nodes.count == 1){
                
                bestSet = theNode.bestSet!;
                
            }
            
            l = l - 1;
            
        }
        
        idealRhymeValue = bestSet.rhymeValueForSet;
        print("Ideal Rhyme Value: ", idealRhymeValue);
        
        var rhymeValue = idealRhymeValue;
        print("Deduction: ", findDeductionForSyllableIndexSet(bestSet, longerSyllable: longerSyllable));
        
        rhymeValue = rhymeValue - findDeductionForSyllableIndexSet(bestSet, longerSyllable: longerSyllable);
        print("Rhyme Value: ", rhymeValue);
        
        return rhymeValue;
        
    }
    
    func findRVBetweenPhonemes(p1: Phoneme, p2: Phoneme) -> Double {
        
        if(p1.isAVowelPhoneme == true && p2.isAVowelPhoneme == true){
            
            let stressDifference = Double(abs(p1.stress - p2.stress));
            
            if(p1.isEqualTo(p2)){
                
                return SAME_VOWEL - 1.5*stressDifference;
                
            }else{
                
                return DIFFERENT_VOWEL - 1.5*stressDifference;
                
            }
            
        }else if(p1.isAVowelPhoneme == false && p2.isAVowelPhoneme == false){
            
            if(p1.isEqualTo(p2)){
                
                return SAME_CONSONANT;
                
            }else{
                
                return DIFFERENT_CONSONANT;
                
            }
            
        }else{
            
            return 0.0;
            
        }
        
    }
    
    func findDeductionForWordIndexSet(bestSet: IndexSet, longerWord: Word) -> Double{
        
        var deduction = 0.0;
        
        if(bestSet.indexes[0] > 0){
            
            if(bestSet.indexes[0] > 1){
                
                print("log10 being applied on: ", Double(bestSet.indexes[0]));
                deduction = deduction + log10(Double(bestSet.indexes[0]));
                
            }else{
                
                deduction = deduction + 0.25;
                
            }
            
        }
        
        if((longerWord.listOfSyllables.count - 1) - bestSet.indexes[bestSet.indexes.count-1] > 0){
            
            print("Another log10 being applied on: ", Double((longerWord.listOfSyllables.count - 1) - bestSet.indexes[bestSet.indexes.count-1]));
            deduction = deduction + log10(Double((longerWord.listOfSyllables.count - 1) - bestSet.indexes[bestSet.indexes.count-1]));
            
        }
        
        var i = 0;
        for set in bestSet.indexes{
            
            if(i == bestSet.indexes.count - 1){
            
                break;
            
            }
            
            let index1 = set;
            let index2 = bestSet.indexes[i+1];
            
            deduction = deduction + (0.25 * Double(index2 - index1 - 1));
            
            i = i + 1;
            
        }
        
        return deduction;
        
    }
    
    func findDeductionForSyllableIndexSet(bestSet: IndexSet, longerSyllable: Syllable) -> Double{
        
        var deduction = 0.0;
        
        if(bestSet.indexes[0] > 0){
            
            if(bestSet.indexes[0] > 1){
                
                print("log10 being applied on: ", Double(bestSet.indexes[0]));
                deduction = deduction + log10(Double(bestSet.indexes[0]));
                
            }else{
                
                deduction = deduction + 0.25;
                
            }
            
        }
        
        if((longerSyllable.listOfPhonemes.count - 1) - bestSet.indexes[bestSet.indexes.count-1] > 0){
            
            print("Another log10 being applied on: ", Double((longerSyllable.listOfPhonemes.count - 1) - bestSet.indexes[bestSet.indexes.count-1]));
            deduction = deduction + log10(Double((longerSyllable.listOfPhonemes.count - 1) - bestSet.indexes[bestSet.indexes.count-1]));
            
        }
        
        var i = 0;
        for set in bestSet.indexes{
            
            if(i == bestSet.indexes.count - 1){
                
                break;
                
            }
            
            let index1 = set;
            let index2 = bestSet.indexes[i+1];
            
            deduction = deduction + (0.25 * Double(index2 - index1 - 1));
            
            i = i + 1;
            
        }
        
        return deduction;
        
    }
    
    func charIsMember(char: Character, inSet set: NSCharacterSet) -> Bool {
        var found = true
        for ch in String(char).utf16 {
            if !set.characterIsMember(ch) { found = false }
        }
        return found;
    }
    
    func debugPrint(obj: AnyObject){
        
        if(DEBUGGING){
            
            print(obj);
            
        }
        
    }

}