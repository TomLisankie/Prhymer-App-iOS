//
//  Point.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 1/12/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

class WordIndexRhymePercentilePair {
    
    var word = "";
    var rhymePercentile = 0.0;
    
    init(){}
    
    init(word: String, rhymePercentile: Double){
    
        self.word = word;
        self.rhymePercentile = rhymePercentile;
    
    }
    
}