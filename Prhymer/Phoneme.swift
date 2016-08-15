//
//  Phoneme.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 12/28/15.
//  Copyright © 2015 Shaken Earth. All rights reserved.
//

import Foundation

struct Phoneme {
    var phoneme = "";
    var isAVowelPhoneme = false;
    var stress = -1;
    
    init?(phonemeName: String){
        
        phoneme = phonemeName;
        
        if(phoneme.hasSuffix("0") || phoneme.hasSuffix("1") || phoneme.hasSuffix("2") || phoneme.hasSuffix("3") || phoneme.hasSuffix("4") || phoneme.hasSuffix("5")) {
            
            let stressText = phoneme.substringFromIndex(phoneme.endIndex.predecessor());
            let thePhoneme = phoneme.substringToIndex(phoneme.endIndex.predecessor());
            self.phoneme = thePhoneme;
            
            if(stressText != ""){
                
                stress = Int(stressText)!;
                
            }
            
        }
        
        if(phoneme == "AA" || phoneme == "AE" || phoneme == "AH" || phoneme == "AO" || phoneme == "AW" || phoneme == "AY" || phoneme == "EH" || phoneme == "ER" || phoneme == "EY" || phoneme == "IH" || phoneme == "IY" || phoneme == "OW" || phoneme == "OY" || phoneme == "UH" || phoneme == "UW" || phoneme == "AR" || phoneme == "EL" || phoneme == "OL" || phoneme == "OR" || phoneme == "ALE" || phoneme == "EAR"){
            
            isAVowelPhoneme = true;
            
        }
        
    }
    
    func isALongVowelPhoneme() -> Bool {
        
        if(phoneme == "AO" || phoneme == "AW" || phoneme == "AY" || phoneme == "EY" || phoneme == "IY" || phoneme == "OW" || phoneme == "OY" || phoneme == "UW" || phoneme == "OL" || phoneme == "OR" || phoneme == "ALE" || phoneme == "EAR" || phoneme == "AR"){
            
            return true;
            
        }else{
            
            return false;
            
        }
        
    }
    
    func isEqualTo(p2: Phoneme) -> Bool{
        
        if(self.phoneme == p2.phoneme){
            
            return true;
            
        }else{
            
            return false;
            
        }
        
    }
    
}

