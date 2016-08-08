//
//  Syllable.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 8/1/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

struct Syllable {
    
    var listOfPhonemes: [Phoneme];
    
    init(listOfPhonemes: [Phoneme]){
    
        self.listOfPhonemes = listOfPhonemes;
    
    }
    
    init(){
    
        listOfPhonemes = [Phoneme]();
    
    }
    
    mutating func addPhoneme(p: Phoneme) {
        
        if(p.phoneme == "N") {
            
            //p.phoneme = "M"
            
        }
        
        listOfPhonemes.append(p);
        
    }
    
}