//
//  Word.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 1/12/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

struct Word {
    let wordName: String;
    let listOfPhonemes: [Phoneme];
    var numOfSyllables: Int;
    
    init?(wordName: String, phonemeString: String) {
        
        self.wordName = wordName;
        listOfPhonemes = phonemeString.componentsSeparatedByString(" ").map { Phoneme(phonemeName: $0)! }
        
        numOfSyllables = 0;
        for phoneme in listOfPhonemes{
            
            if(phoneme.isAVowelPhoneme == true){
                
                numOfSyllables = numOfSyllables + 1;
                
            }
            
        }
        
    }
    
    init?(line: String) {
        
        let components = line.componentsSeparatedByString("  ")
        guard components.count == 2 else { return nil }
        
        wordName = components[0].lowercaseString;
        listOfPhonemes = components[1].componentsSeparatedByString(" ").map { Phoneme(phonemeName: $0)! }
        
        numOfSyllables = 0;
        for phoneme in listOfPhonemes{
        
            if(phoneme.isAVowelPhoneme == true){
            
                numOfSyllables = numOfSyllables + 1;
            
            }
        
        }
        
    }
    
    init() {
        wordName = "";
        listOfPhonemes = [Phoneme]();
        numOfSyllables = 0;
    }
    
    init?(wordName: String, phonemes: [Phoneme]) {
        
        self.wordName = wordName;
        self.listOfPhonemes = phonemes;
        
        numOfSyllables = 0;
        for phoneme in listOfPhonemes{
            
            if(phoneme.isAVowelPhoneme == true){
                
                numOfSyllables = numOfSyllables + 1;
                
            }
            
        }
        
    }
    
}
