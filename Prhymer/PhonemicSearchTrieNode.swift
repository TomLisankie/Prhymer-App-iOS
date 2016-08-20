//
//  PhonemicSearchTrieNode.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 8/14/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

class PhonemicSearchTrieNode {
    
    var phonemeName: String;
    var isFinalPhoneme: Bool;
    var wordNames: [WordName];
    var depth: Int;
    var childrenArray: [PhonemicSearchTrieNode];
    
    init(){
        
        phonemeName = "";
        isFinalPhoneme = true;
        wordNames = [WordName]();
        depth = 0;
        childrenArray = [PhonemicSearchTrieNode]();
        
    }
    
    func addChild(phoneme: String) -> Bool{
        
        isFinalPhoneme = false;
        
        for child in childrenArray{
            
            if(child.phonemeName == phoneme){
                
                return false;
                
            }
            
        }
        
        let newNode = PhonemicSearchTrieNode();
        newNode.phonemeName = phoneme;
        newNode.depth = self.depth + 1;
        
        childrenArray.append(newNode);
        
        //TODO Need to fix this so words aren't added to every child
        
        return true;
        
    }
    
    func removeChild(){
        
        
        
    }
    
    func getChild(phoneme: String) -> PhonemicSearchTrieNode{
        
        for child in childrenArray{
            
            if(child.phonemeName == phoneme){
                
                return child;
                
            }
            
        }
        
        return PhonemicSearchTrieNode();
        
    }
    
    func getChildrenValues() -> [String]{
        
        var childrenValues = [String]();
        
        for child in childrenArray{
            
            childrenValues.append(child.phonemeName);
            
        }
        
        return childrenValues;
        
    }
    
    func getChildrenNodes() -> [PhonemicSearchTrieNode]{
        
        return childrenArray;
        
    }
    
}