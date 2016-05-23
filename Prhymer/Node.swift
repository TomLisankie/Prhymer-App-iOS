//
//  Node.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 2/9/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

class Node {
    
    var indexSets = [IndexSet]();
    var parentIndexSet: IndexSet?;
    var bestSet : IndexSet?;
    
    func addIndexSet(set: IndexSet){
    
        indexSets.append(set);
    
    }
    
    init(){
    
        indexSets = [IndexSet]();
    
    }
    
    func findBestIndexSetAndSendItUp(){
    
        var bestSet = IndexSet(index: 0, RVBetweenPhonemes: 0);
        
        var first = true;
        
        for indexSet in indexSets{
        
            if(first){
                
                bestSet = indexSet;
                first = false;
                
            }else{
                
                if(indexSet.rhymeValueForSet > bestSet.rhymeValueForSet){
                    
                    bestSet = indexSet;
                    
                }
                
            }
        
        }
        
        self.bestSet = bestSet;
        
        if(parentIndexSet != nil){
        
            parentIndexSet?.addIndexes(bestSet.indexes, RVBetweenPhonemes: self.bestSet!.rhymeValueForSet);
        
        }
    
    }
    
}