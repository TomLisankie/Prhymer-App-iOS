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
    var childrenMap: NSMapTable;
    
    init(){
    
        word = nil;
        isFinalChar = true;
    
    }
    
    func addChild(charValue: Character) -> Bool{
    
        return false;
    
    }
    
    func getChild(charValue: Character) -> RhymeDictionaryTrieNode{
    
        return RhymeDictionaryTrieNode();
    
    }
    
}
