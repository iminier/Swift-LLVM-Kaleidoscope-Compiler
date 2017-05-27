//
//  ParseError.swift
//  Kaleidoscope Compiler in Swift
//
//  Created by Ivan Minier on 5/27/17.
//  Copyright © 2017 Ivan Minier. All rights reserved.
//

enum ParseError: Error {
    case unexpectedToken(Token)
    case unexpectedEOF
}
