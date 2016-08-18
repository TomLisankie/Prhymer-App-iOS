//
//  PhonemicSearchTrieNode.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 8/14/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

class PhonemicSearchTrieNode {
    
    var word: Word?;
    var isFinalChar: Bool;
    var charValue: Character;
    var depth: Int;
    var childrenArray: [PhonemicSearchTrieNode];
    
    init(){
        
        word = nil;
        isFinalChar = true;
        charValue = ".";
        depth = 0;
        childrenArray = [PhonemicSearchTrieNode]();
        
    }
    
    func addChild(charValue: Character) -> Bool{
        
        isFinalChar = false;
        
        for child in childrenArray{
            
            if(child.charValue == charValue){
                
                return false;
                
            }
            
        }
        
        let newNode = PhonemicSearchTrieNode();
        newNode.charValue = charValue;
        newNode.depth = self.depth + 1;
        
        childrenArray.append(newNode);
        
        //TODO Need to fix this so words aren't added to every child
        
        return true;
        
    }
    
    func removeChild(){
        
        
        
    }
    
    func getChild(charValue: Character) -> PhonemicSearchTrieNode{
        
        for child in childrenArray{
            
            if(child.charValue == charValue){
                
                return child;
                
            }
            
        }
        
        return PhonemicSearchTrieNode();
        
    }
    
    func getChildrenValues() -> [Character]{
        
        var childrenValues = [Character]();
        
        for child in childrenArray{
            
            childrenValues.append(child.charValue);
            
        }
        
        return childrenValues;
        
    }
    
    func getChildrenNodes() -> [PhonemicSearchTrieNode]{
        
        return childrenArray;
        
    }
    
}