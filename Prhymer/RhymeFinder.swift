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
    var trie = RhymeDictionaryTrie();
    
    init(pathToDict: String) {
        
        buildWords(pathToDict);
        
    }
    
    func buildWords(pathToDict: String){ //builds the list of Word objects that can be compared to one another
        
        let start = NSDate();
        
        let stringData = try! String(contentsOfFile: pathToDict, encoding: NSASCIIStringEncoding)
        let lines = stringData.componentsSeparatedByString("\n").filter { !$0.hasPrefix(";;;") && !$0.isEmpty }
        let anchorWords = lines.flatMap { Word(line: $0) };
        
        anchors = anchorWords;
        
        //now put this list of Words into a trie
        for(var i = 0; i < anchors.count; i++){
            
            trie.addWord(anchors[i]);
            
        }
        
        print("trie created");
        
        //anchorWords = [Word]();
        anchors = anchorWords;
        
        print("done");
        
        print("Dictionary created in \(NSDate().timeIntervalSince1970 - start.timeIntervalSince1970) seconds.")
        
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
            
            for(var s = 0; s < anchor.listOfPhonemes.count; s++){
                
                rhymeValue = rhymeValue + findRVBetweenPhonemes(anchor.listOfPhonemes[s],
                                                                p2: satellite.listOfPhonemes[s], addWeight: true, weight: Double(s)*weightTowardsWordEnd);
                
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
        
        for(var s = 0; s < shorterWord.listOfPhonemes.count; s++){
            
            let weightTowardsWordEnd = 0.1;
            
            if(firstSearch == true){
                debugPrint("firstSearch = true");
                let startNode = Node(); //problem is occuring here
                debugPrint("startNode created");
                for(var l = 0; l < longerWord.listOfPhonemes.count; l++){
                    print("l: ", l);
                    let RVBetweenPhonemes = findRVBetweenPhonemes(shorterWord.listOfPhonemes[s], p2: longerWord.listOfPhonemes[l], addWeight: true, weight: Double(l)*weightTowardsWordEnd);
                    
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
                
                for(var n = 0; n < layers[pastLayerNumber].nodes.count; n++){
                    
                    let nodeBeingExamined = layers[pastLayerNumber].nodes[n];
                    
                    for(var i = 0; i < nodeBeingExamined.indexSets.count; i++){
                        
                        let setBeingExamined = nodeBeingExamined.indexSets[i];
                        let childNode = Node();
                        let indexToStartAt = setBeingExamined.indexes[0];
                        
                        if(indexToStartAt + 1 == longerWord.listOfPhonemes.count){
                            
                            //do nothing
                            
                        }else{
                            
                            for(var l = indexToStartAt + 1; l < longerWord.listOfPhonemes.count; l++){
                                
                                let RVBetweenPhonemes = findRVBetweenPhonemes(shorterWord.listOfPhonemes[s], p2: longerWord.listOfPhonemes[l], addWeight: true, weight: Double(l)*weightTowardsWordEnd);
                                
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
            
        }
        
        //find best path
        
        var bestSet = IndexSet(index: 0, RVBetweenPhonemes: 0.0);
        var nodeBeingExamined = Node();
        
        for(var l = layers.count - 1; l >= 0; l--){
            
            for(var n = 0; n < layers[l].nodes.count; n++){
                
                nodeBeingExamined = layers[l].nodes[n];
                
                if(nodeBeingExamined.indexSets.count > 0){
                    
                    nodeBeingExamined.findBestIndexSetAndSendItUp();
                    
                }
                
            }
            
            if(l == 0 && layers[l].nodes.count == 1){
                
                bestSet = nodeBeingExamined.bestSet;
                
            }
            
        }
        
        idealRhymeValue = bestSet.rhymeValueForSet;
        
        var rhymeValue = idealRhymeValue;
        
        rhymeValue = rhymeValue - findDeductionForIndexSet(bestSet, longerWord: longerWord);
        
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
        
        for(var i = 0; i < longerWord.listOfPhonemes.count; i++){
            
            homophonicRhymeValue = homophonicRhymeValue + findRVBetweenPhonemes(longerWord.listOfPhonemes[i], p2: longerWord.listOfPhonemes[i], addWeight: true, weight: Double(i)*weightTowardsWordEnd);
            
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
        
        for(var i = 0; i < bestSet.indexes.count - 1; i++){
            
            let index1 = bestSet.indexes[i];
            let index2 = bestSet.indexes[i+1];
            
            deduction = deduction + (0.25 * Double(index2 - index1-1));
            
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