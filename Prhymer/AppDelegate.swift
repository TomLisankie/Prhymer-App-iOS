//
//  AppDelegate.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 12/28/15.
//  Copyright © 2015 Shaken Earth. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let DEBUGGING = false;
    var anchors = [Word]();
    var trie = RhymeDictionaryTrie();

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        buildWords();
        
        return true
    }
    
    func buildWords(){ //builds the list of Word objects that can be compared to one another
        
        var phonemes = [Phoneme]();
        var linesOfDictionary  = [String]();
        
        let path = NSBundle.mainBundle().pathForResource("cmudict-0.7b_modified", ofType: "txt");
        
        var i = 0;
        
        //reads in the dictionary's original text file
        if let aStreamReader = StreamReader(path: path!) {
            
            defer {
                
                aStreamReader.close();
                
            }
            
            while let line = aStreamReader.nextLine() {
                
                linesOfDictionary.append(line);
                
                debugPrint(linesOfDictionary[i]);
                
                i = i + 1;
                
            }
            
        }
        
        print("read in text file");
        
        //takes the read in original text file and breaks each line into word names and lists of phonemes; sets up resources for the dictionary.
        var wordNames = [String]();
        var listsOfPhonemesForWords = [[Phoneme]]();
        
        var word = "";
        debugPrint(linesOfDictionary.count);
        var spacesToSkip = 2;
        
        var lineBeingExamined = "";
        
        var indexOfCharBeingExamined = 0;
        
        for line in linesOfDictionary{//goes through every line of the dictionary
            
            spacesToSkip = 2;
            
            lineBeingExamined = line;
            
            indexOfCharBeingExamined = 0;
            
            var charBeingExamined: Character;
            
            for character in lineBeingExamined.characters{//goes through each character in whichever line is being examined
                //need to fix this to use a for-in loop
                
                indexOfCharBeingExamined = indexOfCharBeingExamined + 1;
                
                charBeingExamined = character;
                
                if(charBeingExamined != " " && charBeingExamined != "("){
                    
                    word = word + String(charBeingExamined);
                    
                }else if(charBeingExamined == "("){
                    
                    spacesToSkip = spacesToSkip + 3;
                    wordNames.append(word);
                    word = "";
                    break;
                    
                }else{
                    
                    wordNames.append(word);
                    word = "";
                    break;
                    
                }
                
            }
            
            //print(i);
            indexOfCharBeingExamined = indexOfCharBeingExamined + spacesToSkip;
            phonemes = [Phoneme]();
            var phoneme = Phoneme();
            var phonemeName = "";
            
            //creates a list of phonemes
            
            let lineBeingExaminedChars = Array(lineBeingExamined.utf16[indexOfCharBeingExamined...lineBeingExamined.utf16.count]); //do a subarray of this from indexOfCharBeingExamined to the end so that a for-in loop can be used after. Some conversion may be necessary
            
            for(var k = indexOfCharBeingExamined; k < lineBeingExaminedChars.count; k++){
                
                let charBeingExamined = lineBeingExamined[lineBeingExamined.startIndex.advancedBy(k)]; //this is returning an Int16 not a character for some reason
                let charBeingExaminedUnichar = lineBeingExaminedChars[lineBeingExaminedChars.startIndex.advancedBy(k)];
                
                if(NSCharacterSet.letterCharacterSet().characterIsMember(charBeingExaminedUnichar)) {
                    
                    phonemeName = phonemeName + String(lineBeingExamined[lineBeingExamined.startIndex.advancedBy(k)]);
                    debugPrint("added character to phonemeName");
                    
                }else if NSCharacterSet.decimalDigitCharacterSet().characterIsMember(charBeingExaminedUnichar) {
                    
                    let stress16 = charBeingExaminedUnichar;
                    let stress = Int(stress16);
                    
                    phoneme.stress = stress;
                    
                    debugPrint("added stress to phoneme");
                    
                }else if(String(charBeingExamined) == " "){ //this is never being ran
                    
                    phoneme.phoneme = phonemeName;
                    phonemes.append(phoneme);
                    phoneme = Phoneme();
                    phonemeName = "";
                    debugPrint("space encountered, should move on to next phoneme");
                    
                }else{}
                
            }
            
            //for the last phoneme
            phoneme.phoneme = phonemeName;
            phonemes.append(phoneme);
            phoneme = Phoneme();
            phonemeName = "";
            
            listsOfPhonemesForWords.append(phonemes);
            
        }
        
        //builds dictionary
        var anchorWords = [Word]();
        
        for(var f = 0; f < wordNames.count; f++){
            
            autoreleasepool{
                
                anchorWords.append(Word(wordName:(wordNames[f].lowercaseString), phonemes: listsOfPhonemesForWords[f]));
                
            }
            
        }
        
        anchors = anchorWords;
        
        //now put this list of Words into a trie
        for(var i = 0; i < anchors.count; i++){
            
            trie.addWord(anchors[i]);
            
        }
        
        anchorWords = [Word]();
        anchors = [Word]();
        
    }
    
    func findRhymeValueAndPercentileForWords(anchor: Word, satellite: Word) -> Double{
        
        var rhymePercentile = 0.0;
        
        if(anchor.listOfPhonemes.count == satellite.listOfPhonemes.count){
            
            rhymePercentile = regularRhymeValue(anchor, satellite: satellite);
            
        }else{
            
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
            
            let shortenedListOfPhonemes = Array(anchor.listOfPhonemes[1...anchor.listOfPhonemes.count]);
            
            newWord = Word(wordName: anchor.wordName, phonemes: shortenedListOfPhonemes);
            
            anchorOrSatellite = true;
            
        }else if(satellite.listOfPhonemes[0].isAVowelPhoneme == false && satellite.listOfPhonemes[1].isAVowelPhoneme == false && anchor.listOfPhonemes[0].isEqualTo(satellite.listOfPhonemes[0]) == false && anchor.listOfPhonemes[1].isEqualTo(satellite.listOfPhonemes[1]) == false){
            
            foundConsonantCluster = true;
            
            let shortenedListOfPhonemes = Array(satellite.listOfPhonemes[1...anchor.listOfPhonemes.count]);
            
            newWord = Word(wordName: anchor.wordName, phonemes: shortenedListOfPhonemes); //may want to switch this to satellite rather than anchor
            
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
                
                let startNode = Node();
                for(var l = 0; l < longerWord.listOfPhonemes.count; l++){
                    
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
    
    func debugPrint(obj: AnyObject){
        
        if(DEBUGGING){
            
            print(obj);
            
        }
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

