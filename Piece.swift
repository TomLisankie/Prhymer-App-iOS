//
//  Piece.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 6/28/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

@objc(Piece)
class Piece : NSObject, NSCoding {
    
    var title: String?;
    var content: String?;
    //date of creation
    
    init(title: String){
    
        self.title = title;
        content = "";
    
    }
    
    required init(coder aDecoder: NSCoder) {
        
        if let title = aDecoder.decodeObjectForKey("title") as? String {
            
            self.title = title;
            
        }
        
        if let content = aDecoder.decodeObjectForKey("content") as? String {
            
            self.content = content;
            
        }
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        if let title = self.title {
            
            aCoder.encodeObject(title, forKey: "title")
            
        }
        
        if let content = self.content {
            
            aCoder.encodeObject(content, forKey: "content")
            
        }
        
    }
    
}