//
//  ViewController.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 12/28/15.
//  Copyright © 2015 Shaken Earth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let DEBUGGING = true;
    
    @IBAction func buttonTapped(){
    
        print("hello")
        let sampleNeme = Phoneme();
        sampleNeme.phoneme = "AH";
        print(sampleNeme.phoneme);
        
        buildWords();
    
    }
    
    func buildWords(){
    
        var phonemes = [Phoneme]();
        var linesOfDictionary  = [String?]();
        
        let path = NSBundle.mainBundle().pathForResource("cmudict-0.7b_modified", ofType: "txt");
        
        var i = 0;
        
        //reads in the dictionary's original text file
        if let aStreamReader = StreamReader(path: path!) {
            
            defer {
                
                aStreamReader.close();
                
            }
            
            while let line = aStreamReader.nextLine() {
                
                linesOfDictionary.append(line);
                
                debugPrint(linesOfDictionary[i]!);
                
                i = i + 1;
                
            }
            
        }
        
        //takes the read in original text file and breaks each line into word names and lists of phonemes; sets up resources for the dictionary.
        var wordNames = [String]();
        var listsOfPhonemesForWords = [[Phoneme]]();
        
        var word = "";
        debugPrint(linesOfDictionary.count);
        var spacesToSkip = 2;
        
        var lineBeingExamined = "";
        
        var indexOfCharBeingExamined = 0;
        
        for(var i = 0; i < linesOfDictionary.count; i++){//goes through every line of the dictionary
        
            spacesToSkip = 2;
            
            lineBeingExamined = linesOfDictionary[i]!;
            linesOfDictionary[i] = nil;
            
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
                
                print(i);
                indexOfCharBeingExamined = indexOfCharBeingExamined + spacesToSkip;
                var phoneme = Phoneme();
                var phonemeName = "";
                
                //creates a list of phonemes
                
                let lineBeingExaminedChars = lineBeingExamined.utf16;
                
                for(var k = indexOfCharBeingExamined; k < lineBeingExaminedChars.count; k++){
                
                    let charBeingExamined = lineBeingExaminedChars[lineBeingExaminedChars.startIndex.advancedBy(k)];
                    
                    if(NSCharacterSet.letterCharacterSet().characterIsMember(charBeingExamined)) {
                        
                        phonemeName = phonemeName + String(lineBeingExamined[lineBeingExamined.startIndex.advancedBy(k)]);
                        
                    }else if NSCharacterSet.decimalDigitCharacterSet().characterIsMember(charBeingExamined) {
                        
                        let stress16 = charBeingExamined;
                        let stress = Int(stress16);
                        
                        phoneme.stress = stress;
                        
                    }else if(String(charBeingExamined) == " "){
                    
                        phoneme.phoneme = phonemeName;
                        phonemes.append(phoneme);
                        phoneme = Phoneme();
                        phonemeName = "";
                    
                    }else{}
                
                }
                
                //for the last phoneme
                phoneme.phoneme = phonemeName;
                phonemes.append(phoneme);
                phoneme = Phoneme();
                phonemeName = "";
                
                listsOfPhonemesForWords.append(phonemes);
            
            }
            
        }
        
        //builds dictionary
        var anchorWords = [Word]();
        
        for(var f = 0; f < wordNames.count; f++){
        
            autoreleasepool{
                
                anchorWords.append(Word(wordName:(wordNames[f].lowercaseString), phonemes: listsOfPhonemesForWords[f]));
                
            }
                
        }
        
        print("hello");
        print(anchorWords[145].wordName);
        
        //now put this list of Words into a trie
        
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

