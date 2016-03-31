//
//  IndexSet.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 2/9/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

class IndexSet {
    
    var indexes = [Int]();
    var rhymeValueForSet = 0.0;
    var childNode = Node();
    
    init(index: Int, RVBetweenPhonemes: Double){
        
        print("IndexSet beginning to be initialized");
        indexes.append(index);
        rhymeValueForSet = rhymeValueForSet + RVBetweenPhonemes;
        print("IndexSet successfully initialized");
    
    }
    
    func addIndexes(indexesToAdd: [Int], RVBetweenPhonemes: Double){
    
        for(var i = 0; i < indexesToAdd.count; i++){
        
            indexes.append(indexesToAdd[i]);
        
        }
        
        rhymeValueForSet = rhymeValueForSet + RVBetweenPhonemes;
    
    }
    
    func attachChildNode(childNode: Node){
    
        self.childNode = childNode;
        self.childNode.parentIndexSet = self;
    
    }
    
}