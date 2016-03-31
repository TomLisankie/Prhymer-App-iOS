//
//  Phoneme.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 12/28/15.
//  Copyright © 2015 Shaken Earth. All rights reserved.
//

import Foundation

class Phoneme {
    
    var isAVowelPhoneme = false;
    var phoneme = "";
    var stress = -1;
    
    func setPhonemeName(phonemeName: String){
    
        phoneme = phonemeName;
        
        if(phoneme == "AA" || phoneme == "AE" || phoneme == "AH" || phoneme == "AO" || phoneme == "AW" || phoneme == "AY" || phoneme == "EH" || phoneme == "ER" || phoneme == "EY" || phoneme == "IH" || phoneme == "IY" || phoneme == "NG" || phoneme == "OW" || phoneme == "OY" || phoneme == "UH" || phoneme == "UW"){
        
            isAVowelPhoneme = true;
        
        }
    
    }
    
    func isEqualTo(p2: Phoneme) -> Bool{
    
        if(self.phoneme == p2.phoneme){
        
            return true;
        
        }else{
        
            return false;
        
        }
    
    }
    
    deinit{
    
        //print("Phoneme deinitializing");
    
    }
    
}