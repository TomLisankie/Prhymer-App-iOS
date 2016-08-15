//
//  WordName.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 8/14/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

class WordName : Hashable {
    
    var wordName : String;
    
    init(wordName : String){
    
        self.wordName = wordName;
    
    }
    
    var hashValue : Int {
        
        return wordName.hashValue;
        
    }
    
}

func ==(first : WordName, second : WordName) -> Bool {
    
    return first.hashValue == second.hashValue;
    
}