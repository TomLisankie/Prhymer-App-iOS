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
        
        if(word.wordNameObj.wordName == ""){
            
            return false;
            
        }
        
        var tempRoot = trieRoot;
        
        for syllable in word.listOfSyllables.reverse(){
            
            tempRoot.addChild(syllable.vowelPhoneme.phoneme);
            tempRoot = tempRoot.getChild(syllable.vowelPhoneme.phoneme);
            
        }
        
        tempRoot.wordNames.append(word.wordNameObj);
        tempRoot.isFinalPhoneme = true;
        
        return true;
        
    }//left off here
    
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