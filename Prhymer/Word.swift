//
//  Word.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 1/12/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

class Word {
    
    var wordName = "";
    var listOfPhonemes = [Phoneme]();
    var wordsThisRhymesWith = [WordIndexRhymePercentilePair]();
    var numOfSyllables = 0;
    
    init(){}
    
    init (wordName: String, phonemes: [Phoneme]) {
        
        self.wordName = wordName;
        self.listOfPhonemes = phonemes;
        
    }
    
    func addWordThisRhymesWith(wordIndex: Int, rhymePercentile: Double){
    
        let wordToBeInserted = WordIndexRhymePercentilePair(wordIndex: wordIndex, rhymePercentile: rhymePercentile);
        
        wordsThisRhymesWith.append(wordToBeInserted);
        
        //TODO add way of sorting these
    
    }
    
    deinit{
        
        //print("Word deinitializing");
        
    }
    
}
