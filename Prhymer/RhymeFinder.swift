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
    var dictionary = [String : Word]();
    
    init(pathToDict: String) {
        
        buildWords(pathToDict);
        
    }
    
    init(dict: [String : Word]) {
        
        
        
    }
    
    func buildWords(pathToDict: String){ //builds the list of Word objects that can be compared to one another
        debugPrint("starting");
        let start = NSDate();
        
        let stringData = try! String(contentsOfFile: pathToDict, encoding: NSASCIIStringEncoding)
        let lines = stringData.componentsSeparatedByString("\n").filter { !$0.hasPrefix(";;;") && !$0.isEmpty }
        let anchorWords = lines.flatMap { Word(line: $0) };
        
        anchors = anchorWords;
        
        let dictionaryCreationStart = NSDate();

        for anchor in anchors{
        
            dictionary[anchor.wordName] = anchor;
        
        }
        
        print("Dictionary created in \(NSDate().timeIntervalSince1970 - dictionaryCreationStart.timeIntervalSince1970) seconds.");
        
        anchors = anchorWords;
        
        print("buildWords done in \(NSDate().timeIntervalSince1970 - start.timeIntervalSince1970) seconds.");
        
    }
    
    func findRhymeValueAndPercentileForWords(anchor: Word, satellite: Word) -> Double{
        
        var rhymePercentile = 0.0;
        
        if(anchor.listOfPhonemes.count == satellite.listOfPhonemes.count){
            
            debugPrint("Regular Rhyme Value");
            rhymePercentile = regularRhymeValue(anchor, satellite: satellite);
            
        }else{
            
            debugPrint("Ideal Rhyme Value");
            rhymePercentile = idealRhymeValue(anchor, satellite: satellite);
            
        }
        
        return rhymePercentile;
        
    }
    
    func regularRhymeValue(anchor: Word, satellite: Word) -> Double{
        
        var foundConsonantCluster = false;
        var anchorOrSatellite = false;
        
        var rhymeValue = 0.0;
        
        var newWord = Word();
        
        let weightTowardsWordEnd = 0.1;
        
        if(anchor.listOfPhonemes[0].isAVowelPhoneme == false && anchor.listOfPhonemes[1].isAVowelPhoneme == false && anchor.listOfPhonemes[0].isEqualTo(satellite.listOfPhonemes[0]) == false && anchor.listOfPhonemes[1].isEqualTo(satellite.listOfPhonemes[1]) == false){
            
            foundConsonantCluster = true;
            print(anchor.listOfPhonemes[0].phoneme);
            let shortenedListOfPhonemes = Array(anchor.listOfPhonemes[1...anchor.listOfPhonemes.count-1]);
            
            newWord = Word(wordName: anchor.wordName, phonemes: shortenedListOfPhonemes)!;
            
            anchorOrSatellite = true;
            
        }else if(satellite.listOfPhonemes[0].isAVowelPhoneme == false && satellite.listOfPhonemes[1].isAVowelPhoneme == false && anchor.listOfPhonemes[0].isEqualTo(satellite.listOfPhonemes[0]) == false && anchor.listOfPhonemes[1].isEqualTo(satellite.listOfPhonemes[1]) == false){
            
            foundConsonantCluster = true;
            
            let shortenedListOfPhonemes = Array(satellite.listOfPhonemes[1...anchor.listOfPhonemes.count-1]);
            
            newWord = Word(wordName: anchor.wordName, phonemes: shortenedListOfPhonemes)!; //may want to switch this to satellite rather than anchor
            
            anchorOrSatellite = false;
            
        }
        
        if(foundConsonantCluster == false){
            
            var counter = 0;
            for anchorPhoneme in anchor.listOfPhonemes{
                
                rhymeValue = rhymeValue + findRVBetweenPhonemes(anchorPhoneme,
                                                                p2: satellite.listOfPhonemes[counter], addWeight: true, weight: Double(counter)*weightTowardsWordEnd);
                
                counter = counter + 1;
                
            }
            
        }else{
            
            //nothing, it'll be taken care of in the next if-else statement.
            
        }
        
        if(foundConsonantCluster == false){
            
            return findRhymePercentile(rhymeValue, longerWord: anchor);
            
        }else{
            
            var longerWord = Word();
            
            if(anchor.listOfPhonemes.count < satellite.listOfPhonemes.count){
                
                longerWord = satellite;
                
            }else{
                
                longerWord = anchor;
                
            }
            
            if(anchorOrSatellite == true){
                
                return idealRhymeValue(newWord, satellite: satellite);
                
            }else{
                
                return idealRhymeValue(anchor, satellite: newWord);
                
            }
            
        }
        
    }
    
    func idealRhymeValue(anchor: Word, satellite: Word) -> Double{
        
        var shorterWord = Word();
        var longerWord = Word();
        
        if(anchor.listOfPhonemes.count < satellite.listOfPhonemes.count){
            
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
        for shorterWordPhoneme in shorterWord.listOfPhonemes{
            
            let weightTowardsWordEnd = 0.1;
            
            if(firstSearch == true){
                debugPrint("firstSearch = true");
                let startNode = Node(); //problem is occuring here
                debugPrint("startNode created");
                var l = 0;
                for longerWordPhoneme in longerWord.listOfPhonemes{
                    
                    l = l + 1;
                    
                    let RVBetweenPhonemes = findRVBetweenPhonemes(shorterWordPhoneme, p2: longerWordPhoneme, addWeight: true, weight: Double(l)*weightTowardsWordEnd);
                    
                    if(RVBetweenPhonemes > 0){
                        
                        foundStartingIndex = true;
                        
                        let indexSet = IndexSet(index: l, RVBetweenPhonemes: RVBetweenPhonemes);
                        
                        startNode.addIndexSet(indexSet);
                        
                    }
                    
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
                        
                        if(indexToStartAt + 1 == longerWord.listOfPhonemes.count){
                            
                            //do nothing
                            
                        }else{
                            
                            var l = 0;
                            for longerWordPhoneme in longerWord.listOfPhonemes{
                                
                                let RVBetweenPhonemes = findRVBetweenPhonemes(shorterWordPhoneme, p2: longerWordPhoneme, addWeight: true, weight: Double(l)*weightTowardsWordEnd);
                                
                                if(RVBetweenPhonemes > 0){
                                    
                                    let indexSet = IndexSet(index: l, RVBetweenPhonemes: RVBetweenPhonemes);
                                    childNode.addIndexSet(indexSet);
                                    
                                }
                                
                                l = l + 1;
                                
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
                print("LAYER IS 0");
                bestSet = theNode.bestSet!;
                
            }
            
            l = l - 1;
            
        }
        
        idealRhymeValue = bestSet.rhymeValueForSet;
        print("Ideal Rhyme Value: ", idealRhymeValue);
        
        var rhymeValue = idealRhymeValue;
        print("Deduction: ", findDeductionForIndexSet(bestSet, longerWord: longerWord));
        
        rhymeValue = rhymeValue - findDeductionForIndexSet(bestSet, longerWord: longerWord);
        print("Rhyme Value: ", rhymeValue);
        
        return findRhymePercentile(rhymeValue, longerWord: longerWord);
        
    }
    
    func findRVBetweenPhonemes(p1: Phoneme, p2: Phoneme, addWeight: Bool, weight: Double) -> Double{
        
        if(p1.isAVowelPhoneme == true && p2.isAVowelPhoneme == true){
            
            if(p1.isEqualTo(p2)){
                
                return 2.0 + weight;
                
            }else{
                
                return 1.0 + weight;
                
            }
            
        }else if(p1.isAVowelPhoneme == false && p2.isAVowelPhoneme == false){
            
            if(p1.isEqualTo(p2)){
                
                return 1.0 + weight;
                
            }else{
                
                return 0.5 + weight;
                
            }
            
        }else{
            
            return 0.0;
            
        }
        
    }
    
    func findRhymePercentile(rhymeValue: Double, longerWord: Word) -> Double{
        
        var homophonicRhymeValue = 0.0;
        var rhymePercentile = 0.0;
        
        let weightTowardsWordEnd = 0.1;
        
        var i = 0;
        for longerWordPhoneme in longerWord.listOfPhonemes{
            
            homophonicRhymeValue = homophonicRhymeValue + findRVBetweenPhonemes(longerWordPhoneme, p2: longerWordPhoneme, addWeight: true, weight: Double(i)*weightTowardsWordEnd);
            
            i = i + 1;
            
        }
        
        rhymePercentile = rhymeValue / homophonicRhymeValue;
        
        return rhymePercentile;
        
    }
    
    func findDeductionForIndexSet(bestSet: IndexSet, longerWord: Word) -> Double{
        
        var deduction = 0.0;
        
        if(bestSet.indexes[0] > 0){
            
            if(bestSet.indexes[0] > 1){
                
                deduction = deduction + log10(Double(bestSet.indexes[0]));
                
            }else{
                
                deduction = deduction + 0.25;
                
            }
            
        }
        
        if((longerWord.listOfPhonemes.count - 1) - bestSet.indexes[bestSet.indexes.count-1] > 0){
            
            deduction = deduction + log10(Double((longerWord.listOfPhonemes.count - 1) - bestSet.indexes[bestSet.indexes.count-1]));
            
        }
        
        var i = 0;
        for set in bestSet.indexes{
            
            if(i == bestSet.indexes.count - 1){
            
                break;
            
            }
            
            let index1 = set;
            let index2 = bestSet.indexes[i+1];
            
            deduction = deduction + (0.25 * Double(index2 - index1-1));
            
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