//
//  RhymeDictionaryTrie.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 2/7/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

class RhymeDictionaryTrie {
    
    var trieRoot: RhymeDictionaryTrieNode;
    
    init(){
    
        trieRoot = RhymeDictionaryTrieNode();
    
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
        
        for(var i = 0; i < wordName.characters.count; i++){
        
            let current = wordName[wordName.startIndex.advancedBy(i)];
            let children = currentNode.getChildrenNodes();
            var foundChar = false;
            
            for(var j = 0; j < children.count; j++){
            
                foundChar = false;
                let child = children[j];
                let childChar = child.charValue;
                
                if(String(childChar) == String(current)){
                
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
        
        return word;
    
    } //okay finished this class, need to fill out RhymeDictionaryTrieNode now.
    
}
