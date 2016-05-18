//
//  Phoneme.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 12/28/15.
//  Copyright © 2015 Shaken Earth. All rights reserved.
//

import Foundation

class Phoneme: NSObject, NSCoding {
    var phoneme = "";
    var isAVowelPhoneme = false;
    var stress = -1;
    
    init?(phonemeName: String){
        
        if(phonemeName.hasSuffix("1") || phonemeName.hasSuffix("2") || phonemeName.hasSuffix("3") || phonemeName.hasSuffix("4") || phonemeName.hasSuffix("5")) {
            
            let stressText = phonemeName.substringFromIndex(phonemeName.endIndex);
            let thePhoneme = phonemeName.substringToIndex(phonemeName.endIndex);
            self.phoneme = thePhoneme;
            if(stressText != ""){
                
                stress = Int(stressText)!;
                
            }
            
        }
        
        if(phonemeName == "AA" || phonemeName == "AE" || phonemeName == "AH" || phonemeName == "AO" || phonemeName == "AW" || phonemeName == "AY" || phonemeName == "EH" || phonemeName == "ER" || phonemeName == "EY" || phonemeName == "IH" || phonemeName == "IY" || phonemeName == "NG" || phonemeName == "OW" || phonemeName == "OY" || phonemeName == "UH" || phonemeName == "UW"){
            
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
    
    func encodeWithCoder(aCoder: NSCoder){
        
        aCoder.encodeObject(phoneme, forKey: "phoneme");
        aCoder.encodeObject(isAVowelPhoneme, forKey: "isAVowelPhoneme");
        aCoder.encodeObject(stress, forKey: "stress");
        
    }
    
    required init?(coder: NSCoder){
        
        phoneme = coder.decodeObjectForKey("phoneme") as? String ?? "";
        isAVowelPhoneme = (coder.decodeObjectForKey("isAVowelPhoneme") as? Bool)!;
        stress = (coder.decodeObjectForKey("stress") as? Int)!;
        
    }
    
}

