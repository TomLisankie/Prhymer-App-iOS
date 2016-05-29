//
//  OrderedDictionary.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 5/28/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

struct OrderedDictionary<KeyType : Hashable, ValueType> {
    
    var keys : Array<KeyType> = Array<KeyType>();
    var values : Dictionary<KeyType, ValueType> = Dictionary<KeyType, ValueType>();
    
    init(){}
    
    subscript(key: KeyType) -> ValueType? {
        get {
            return self.values[key]
        }
        set(newValue) {
            if newValue == nil {
                self.values.removeValueForKey(key)
                self.keys.filter {$0 != key}
                return
            }
            
            let oldValue = self.values.updateValue(newValue!, forKey: key)
            if oldValue == nil {
                self.keys.append(key)
            }
        }
    }
    
}
