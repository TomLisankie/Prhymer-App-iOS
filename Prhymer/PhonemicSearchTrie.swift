//
//  PhonemicSearchTrie.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 8/14/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

class PhonemicSearchTrie {
    
    var trieRoot: PhonemicSearchTrieNode;
    
    init(){
        
        trieRoot = PhonemicSearchTrieNode();
        
    }
    
    func addWord(word: Word) -> Bool{
        
        if(word.wordName == ""){
            
            return false;
            
        }
        
        let wordCharArr = word.wordName.characters;
        var tempRoot = trieRoot;
        
        for phoneme in word.vowelPhonemes.reverse(){
            
            tempRoot.addChild(phoneme.phoneme);
            tempRoot = tempRoot.getChild(phoneme.phoneme);
            
        }
        
        tempRoot.wordNames.append(word.wordNameObj);
        tempRoot.isFinalPhoneme = true;
        
        return true;
        
    }
    
    func getWordsWithSimilarVowelStructure(wordName: WordName) -> [WordName]{ //used to fetch words with same vowel structure
        
        var word = Word(wordName: "", phonemes: [Phoneme]());
        var currentNode = trieRoot;
        
        for phoneme in (word?.vowelPhonemes.reverse())!{
            
            let children = currentNode.getChildrenNodes();
            var foundPhoneme = false;
            
            for child in children{
                
                foundPhoneme = false;
                let childPhoneme = child.phonemeName;
                
                if(childPhoneme == phoneme.phoneme){
                    
                    currentNode = child;
                    foundPhoneme = true;
                    break;
                    
                }
                
            }
            
            if(foundPhoneme == false){
                
                break;
                
            }
            
        }
        
        return currentNode.wordNames;
        
    }
    
}