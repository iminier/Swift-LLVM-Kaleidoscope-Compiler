//
//  Ext-Character.swift
//  Kaleidescope Compiler in Swift
//
//  Created by Ivan Minier on 5/27/17.
//  Copyright © 2017 Ivan Minier. All rights reserved.
//
import Darwin

extension Character {
    
    var value: Int32 {
        return Int32(String(self).unicodeScalars.first!.value)
    }
    
    var isSpace: Bool {
        return isalnum(value) != 0 || self == "_"
    }
    
}
