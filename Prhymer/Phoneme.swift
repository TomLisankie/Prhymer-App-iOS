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
    
    func isEqualTo(p2: Phoneme) -> Bool{
    
        if(self.phoneme == p2.phoneme){
        
            return true;
        
        }else{
        
            return false;
        
        }
    
    }
    
    deinit{
    
        print("Phoneme deinitializing");
    
    }
    
}