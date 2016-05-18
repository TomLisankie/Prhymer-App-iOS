//
//  Word.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 1/12/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

class Word : NSObject, NSCoding {
    let wordName: String;
    let listOfPhonemes: [Phoneme];
    var numOfSyllables: Int;
    
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
    
    override init() {
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
    
    func encodeWithCoder(aCoder: NSCoder){
    
        aCoder.encodeObject(wordName, forKey: "wordName");
        aCoder.encodeObject(listOfPhonemes, forKey: "listOfPhonemes");
        aCoder.encodeObject(numOfSyllables, forKey: "numOfSyllables");
    
    }
    
    required init(coder: NSCoder){
        
        wordName = coder.decodeObjectForKey("wordName") as? String ?? "";
        listOfPhonemes = (coder.decodeObjectForKey("listOfPhonemes") as? [Phoneme])!;
        numOfSyllables = (coder.decodeObjectForKey("numOfSyllables") as? Int)!;
        
    }

    
}
