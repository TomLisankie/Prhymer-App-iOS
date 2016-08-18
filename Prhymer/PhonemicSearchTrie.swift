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
        
        for charValue in wordCharArr{
            
            tempRoot.addChild(charValue);
            tempRoot = tempRoot.getChild(charValue);
            
        }
        
        tempRoot.word = word;
        tempRoot.isFinalChar = true;
        
        return true;
        
    }
    
    func getWord(wordName: String) -> Word{
        
        var word = Word(wordName: "", phonemes: [Phoneme]());
        var currentNode = trieRoot;
        
        for character in wordName.characters{
            
            let children = currentNode.getChildrenNodes();
            var foundChar = false;
            
            for child in children{
                
                foundChar = false;
                let childChar = child.charValue;
                
                if(String(childChar) == String(character)){
                    
                    currentNode = child;
                    foundChar = true;
                    break;
                    
                }
                
            }
            
            if(foundChar == false){
                
                break;
                
            }
            
        }
        
        word = currentNode.word!;
        
        return word!;
        
    } //okay finished this class, need to fill out RhymeDictionaryTrieNode now.
    
}