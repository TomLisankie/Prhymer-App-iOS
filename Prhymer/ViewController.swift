//
//  ViewController.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 12/28/15.
//  Copyright © 2015 Shaken Earth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let DEBUGGING = false;
    var anchors = [Word]();
    var trie = RhymeDictionaryTrie();
    
    @IBAction func buttonTapped(){
    
        print("hello")
        let sampleNeme = Phoneme();
        sampleNeme.phoneme = "AH";
        print(sampleNeme.phoneme);
        
        buildWords();
    
    }
    
    func buildWords(){
    
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
        
        //takes the read in original text file and breaks each line into word names and lists of phonemes; sets up resources for the dictionary.
        var wordNames = [String]();
        var listsOfPhonemesForWords = [[Phoneme]](); /*for something each element in this list contains far more stuff than it ever should.
        It all seems to be duplications of previous elements too. This is likely where the absurd memory problem is coming from*/
        
        var word = "";
        debugPrint(linesOfDictionary.count);
        var spacesToSkip = 2;
        
        var lineBeingExamined = "";
        
        var indexOfCharBeingExamined = 0;
        
        for(var i = 0; i < linesOfDictionary.count; i++){//goes through every line of the dictionary
        
            spacesToSkip = 2;
            
            lineBeingExamined = linesOfDictionary[i];
            
            indexOfCharBeingExamined = 0;
            
            var charBeingExamined: Character;
            
            for (var j = 0; j < lineBeingExamined.characters.count; j++){//goes through each character in whichever line is being examined
            
                indexOfCharBeingExamined = j;
                
                charBeingExamined = lineBeingExamined[lineBeingExamined.startIndex.advancedBy(indexOfCharBeingExamined)];
                
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
                
            print(i);
            indexOfCharBeingExamined = indexOfCharBeingExamined + spacesToSkip;
            phonemes = [Phoneme]();
            var phoneme = Phoneme();
            var phonemeName = "";
            
            //creates a list of phonemes
            
            let lineBeingExaminedChars = lineBeingExamined.utf16;
            
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
        
        for(var i = 0; i < anchors.count; i++){
        
            trie.addWord(anchors[i]);
        
        }
        
        anchorWords = [Word]();
        anchors = [Word]();
        
        print("hello");
        print(anchorWords[145].wordName);
        
        //now put this list of Words into a trie
        
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
        
        
        
    }
    
    func findRVBetweenPhonemes(p1: Phoneme, p2: Phoneme, addWeight: Bool, weight: Double) -> Double{
    
        
    
    }
    
    func findRhymePercentile(rhymeValue: Double, longerWord: Word) -> Double{
    
        
    
    }
    
    func debugPrint(obj: AnyObject){
    
        if(DEBUGGING){
            
            print(obj);
            
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

