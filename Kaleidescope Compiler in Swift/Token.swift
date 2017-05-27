//
//  Token.swift
//  Kaleidescope Compiler in Swift
//
//  Created by Ivan Minier on 5/27/17.
//  Copyright © 2017 Ivan Minier. All rights reserved.
//

enum Token {
    
    case leftParen, rightParen, def, extern, comma, semicolon, `if`, then, `else`
    case identifier(String)
    case number(Double)
    case `operator`(BinaryOperator)
    
}
