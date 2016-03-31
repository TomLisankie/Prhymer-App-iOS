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
    var bestSet = IndexSet(index: 0, RVBetweenPhonemes: 0);
    
    func addIndexSet(set: IndexSet){
    
        indexSets.append(set);
    
    }
    
    func findBestIndexSetAndSendItUp(){
    
        var bestSet = IndexSet(index: 0, RVBetweenPhonemes: 0);
        
        for(var i = 0; i < indexSets.count; i++){
        
            if(i == 0){
                
                bestSet = indexSets[i];
                
            }else{
                
                if(indexSets[i].rhymeValueForSet > bestSet.rhymeValueForSet){
                    
                    bestSet = indexSets[i];
                    
                }
                
            }
        
        }
        
        self.bestSet = bestSet;
        
        if(parentIndexSet != nil){
        
            parentIndexSet?.addIndexes(bestSet.indexes, RVBetweenPhonemes: self.bestSet.rhymeValueForSet);
        
        }
    
    }
    
}