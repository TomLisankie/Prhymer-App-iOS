//
//  Point.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 1/12/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

class WordIndexRhymePercentilePair {
    
    var wordIndex = 0, rhymePercentile = 0.0;
    
    init(){}
    
    init(wordIndex: Int, rhymePercentile: Double){
    
        self.wordIndex = wordIndex;
        self.rhymePercentile = rhymePercentile;
    
    }
    
}