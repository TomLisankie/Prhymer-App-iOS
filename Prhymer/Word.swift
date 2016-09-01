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
    
    init?(wordName: String, phonemeString: String) {
        print(phonemeString);
        self.wordName = wordName;
        listOfPhonemes = phonemeString.componentsSeparatedByString(" ").map { Phoneme(phonemeName: $0)! }
        
        for (mutableIndex, phoneme) in listOfPhonemes.enumerate() {
            print(wordName + " index: ", mutableIndex);
            if (mutableIndex+1 != listOfPhonemes.count) {
                
                if(phoneme.isAVowelPhoneme == true) {
                    
                    if (phoneme.phoneme == "AA" && listOfPhonemes[mutableIndex+1].phoneme == "R") {
                        
                        listOfPhonemes[mutableIndex] = Phoneme(phonemeName: "AR")!;
                        listOfPhonemes.removeAtIndex(mutableIndex+1);
                        print(phoneme.phoneme + " ran");
                        
                    }else if (phoneme.phoneme == "EH" && listOfPhonemes[mutableIndex+1].phoneme == "L") {
                        
                        listOfPhonemes[mutableIndex] = Phoneme(phonemeName: "EL")!;
                        listOfPhonemes.removeAtIndex(mutableIndex+1);
                        print(phoneme.phoneme + " ran");
                        
                    }else if (phoneme.phoneme == "OW" && listOfPhonemes[mutableIndex+1].phoneme == "L") {
                        
                        listOfPhonemes[mutableIndex] = Phoneme(phonemeName: "OL")!;
                        listOfPhonemes.removeAtIndex(mutableIndex+1);
                        print(phoneme.phoneme + " ran");
                        
                    }else if ((phoneme.phoneme == "AO" && listOfPhonemes[mutableIndex+1].phoneme == "R") || (phoneme.phoneme == "UW" && listOfPhonemes[mutableIndex+1].phoneme == "R")) {
                        
                        listOfPhonemes[mutableIndex] = Phoneme(phonemeName: "OR")!;
                        listOfPhonemes.removeAtIndex(mutableIndex+1);
                        print(phoneme.phoneme + " ran");
                        
                    }else if (phoneme.phoneme == "EY" && listOfPhonemes[mutableIndex+1].phoneme == "L") {
                        
                        listOfPhonemes[mutableIndex] = Phoneme(phonemeName: "ALE")!;
                        listOfPhonemes.removeAtIndex(mutableIndex+1);
                        print(phoneme.phoneme + " ran");
                        
                    }else if (phoneme.phoneme == "IY" && listOfPhonemes[mutableIndex+1].phoneme == "R") {
                        
                        listOfPhonemes[mutableIndex] = Phoneme(phonemeName: "EAR")!;
                        listOfPhonemes.removeAtIndex(mutableIndex+1);
                        print(phoneme.phoneme + " ran");
                        
                    }else{
                    
                        //mutableIndex = mutableIndex + 1;
                    
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func getVowelPhonemes() -> [Phoneme] {
        
        var vowelPhonemes = [Phoneme]();
        
        for phoneme in listOfPhonemes {
            
            if phoneme.isAVowelPhoneme {
                
                vowelPhonemes.append(phoneme);
                
            }
            
        }
        
        return vowelPhonemes;
        
    }
    
    func getVowelPhonemesAsString() -> String {
        
        var vowelPhonemeString = "";
        
        for phoneme in getVowelPhonemes() {
            
            vowelPhonemeString = vowelPhonemeString + phoneme.phoneme + " ";
            
        }
        
        return vowelPhonemeString;
        
    }
    
    init?(line: String) {
        
        let components = line.componentsSeparatedByString("  ")
        guard components.count == 2 else { return nil }
        
        wordName = components[0].lowercaseString;
        listOfPhonemes = components[1].componentsSeparatedByString(" ").map { Phoneme(phonemeName: $0)! }
        
    }
    
    init() {
        wordName = "";
        listOfPhonemes = [Phoneme]();
    }
    
    init?(wordName: String, phonemes: [Phoneme]) {
        
        self.wordName = wordName;
        self.listOfPhonemes = phonemes;
        
    }
    
}
