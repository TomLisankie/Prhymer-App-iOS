//
//  RhymeDictionaryTrieNode.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 2/7/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

class RhymeDictionaryTrieNode {
    
    var word: Word?;
    var isFinalChar: Bool;
    var charValue: Character;
    var depth: Int;
    var childrenArray: [RhymeDictionaryTrieNode];
    
    init(){
    
        word = nil;
        isFinalChar = true;
        charValue = ".";
        depth = 0;
        childrenArray = [RhymeDictionaryTrieNode]();
    
    }
    
    func addChild(charValue: Character) -> Bool{
    
        isFinalChar = false;
        
        for(var i = 0; i < childrenArray.count; i++){
        
            if(childrenArray[i].charValue == charValue){
            
                return false;
            
            }
        
        }
        
        let newNode = RhymeDictionaryTrieNode();
        newNode.charValue = charValue;
        newNode.depth = self.depth + 1;
        
        childrenArray.append(newNode);
        
        //TODO Need to fix this so words aren't added to every child
        
        return true;
    
    }
    
    func removeChild(){
    
        
    
    }
    
    func getChild(charValue: Character) -> RhymeDictionaryTrieNode{
    
        for(var i = 0; i < childrenArray.count; i++){
            
            if(childrenArray[i].charValue == charValue){
            
                return childrenArray[i];
            
            }
            
        }
        
        return RhymeDictionaryTrieNode();
    
    }
    
    func getChildrenValues() -> [Character]{
        
        var childrenValues = [Character]();
        
        for(var i = 0; i < childrenArray.count; i++){
        
            childrenValues.append(childrenArray[i].charValue);
        
        }
        
        return childrenValues;
        
    }
    
    func getChildrenNodes() -> [RhymeDictionaryTrieNode]{
    
        return childrenArray;
    
    }
    
}
