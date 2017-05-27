//
//  Ext-Character.swift
//  Kaleidescope Compiler in Swift
//
//  Created by Ivan Minier on 5/27/17.
//  Copyright © 2017 Ivan Minier. All rights reserved.
//

extension Character {
    
    var value: Int32 {
        return Int32(String(self).unicodeScalars.first!.value)
    }
}
