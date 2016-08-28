//
//  Word.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 1/12/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

struct Word : PhonemeSequence {
    let wordName: String;
    var listOfPhonemes: [Phoneme];
    var vowelPhonemes: [Phoneme];
    
    init?(wordName: String, phonemeString: String) {
        
        self.wordName = wordName;
        listOfPhonemes = phonemeString.componentsSeparatedByString(" ").map { Phoneme(phonemeName: $0)! }
        vowelPhonemes = [Phoneme]();
        
        for phoneme in listOfPhonemes{
            
            if(phoneme.isAVowelPhoneme == true){
                
                vowelPhonemes.append(phoneme);
                
            }
            
            //check for environmentally dependent phoneme changes:
            
        }
        
        for (index, phoneme) in listOfPhonemes.enumerate() {
            
            if (index+1 != listOfPhonemes.count) {
                
                if(phoneme.isAVowelPhoneme == true) {
                    
                    if (phoneme.phoneme == "AA" && listOfPhonemes[index+1].phoneme == "R") {
                        
                        listOfPhonemes[index] = Phoneme(phonemeName: "AR")!;
                        listOfPhonemes.removeAtIndex(index+1);
                        
                    }else if (phoneme.phoneme == "EH" && listOfPhonemes[index+1].phoneme == "L") {
                        
                        listOfPhonemes[index] = Phoneme(phonemeName: "EL")!;
                        listOfPhonemes.removeAtIndex(index+1);
                        
                    }else if (phoneme.phoneme == "OW" && listOfPhonemes[index+1].phoneme == "L") {
                        
                        listOfPhonemes[index] = Phoneme(phonemeName: "OL")!;
                        listOfPhonemes.removeAtIndex(index+1);
                        
                    }else if ((phoneme.phoneme == "AO" && listOfPhonemes[index+1].phoneme == "R") || (phoneme.phoneme == "UW" && listOfPhonemes[index+1].phoneme == "R")) {
                        
                        listOfPhonemes[index] = Phoneme(phonemeName: "OR")!;
                        listOfPhonemes.removeAtIndex(index+1);
                        
                    }else if (phoneme.phoneme == "EY" && listOfPhonemes[index+1].phoneme == "L") {
                        
                        listOfPhonemes[index] = Phoneme(phonemeName: "ALE")!;
                        listOfPhonemes.removeAtIndex(index+1);
                        
                    }else if (phoneme.phoneme == "IY" && listOfPhonemes[index+1].phoneme == "R") {
                        
                        listOfPhonemes[index] = Phoneme(phonemeName: "EAR")!;
                        listOfPhonemes.removeAtIndex(index+1);
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    init?(line: String) {
        
        let components = line.componentsSeparatedByString("  ")
        guard components.count == 2 else { return nil }
        
        wordName = components[0].lowercaseString;
        listOfPhonemes = components[1].componentsSeparatedByString(" ").map { Phoneme(phonemeName: $0)! }
        vowelPhonemes = [Phoneme]();
        
        for phoneme in listOfPhonemes{
        
            if(phoneme.isAVowelPhoneme == true){
            
                vowelPhonemes.append(phoneme);
            
            }
        
        }
        
    }
    
    init() {
        wordName = "";
        listOfPhonemes = [Phoneme]();
        vowelPhonemes = [Phoneme]();
    }
    
    init?(wordName: String, phonemes: [Phoneme]) {
        
        self.wordName = wordName;
        self.listOfPhonemes = phonemes;
        vowelPhonemes = [Phoneme]();
        
        for phoneme in listOfPhonemes{
            
            if(phoneme.isAVowelPhoneme == true){
                
                vowelPhonemes.append(phoneme);
                
            }
            
        }
        
    }
    
}
