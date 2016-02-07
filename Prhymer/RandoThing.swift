//
//  File.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 2/6/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

class RandoThing{

    func buildWords(){
    
        var linesOfDictionary = [String]();
        
        let path = NSBundle.mainBundle().pathForResource("cmudict-0.7b_modified", ofType: "txt");
        
        var i = 0;
        
        //reads in the dictionary's original text file
        if let aStreamReader = StreamReader(path: path!) {
            
            defer {
                
                aStreamReader.close();
                
            }
            
            while let line = aStreamReader.nextLine() {
                
                linesOfDictionary.append(line);
                
                debugPrint(linesOfDictionary[i]);
                
                i = i + 1;
                
            }
            
        }
        
        
    
    }

}