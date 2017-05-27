//
//  Lexer.swift
//  Kaleidoscope Compiler in Swift
//
//  Created by Ivan Minier on 5/27/17.
//  Copyright © 2017 Ivan Minier. All rights reserved.
//

import Darwin

class Lexer {
    
    let input: String
    var index: String.Index
    
    init(input: String) {
        self.input = input
        self.index = input.startIndex
    }
    
    var currentChar: Character? {
        return index < input.endIndex ? input[index] : nil
    }
    
    func advanceIndex() {
        input.characters.formIndex(after: &index)
    }
    
    func readIdentifierOrNumber() -> String {
        var str = ""
        while let char = currentChar, char.isAlphanumeric || char == "." {
            str.characters.append(char)
            advanceIndex()
        }
        return str
    }
    
    func advanceToNextToken() -> Token? {
        // Skipp all spaces until a non-space token
        while let char = currentChar, char.isSpace {
            advanceIndex()
        }
        
        guard let char = currentChar else {
            return nil
        }
        
        let singleTokMapping: [Character : Token] = [
            "," : .comma,
            "(" : .leftParen,
            ")" : .rightParen,
            ";" : .semicolon,
            "+" : .operator(.plus),
            "-" : .operator(.minus),
            "*" : .operator(.times),
            "/" : .operator(.divide),
            "%" : .operator(.mod),
            "=" : .operator(.equals)
        ]
        
        if let tok = singleTokMapping[char] {
            advanceIndex()
            return tok
        }
        
        /*
        This is where we parse the identifiers or numbers 
        usinf Swifts built-in double parsin logic
        */
        
        if char.isAlphanumeric {
            let str = readIdentifierOrNumber()
            if let dblVal = Double(str) {
                return .number(dblVal)
            }
            
            // Look for known tokens, otherwise fall back to the 
            // identifier token
            
            switch str {
                case "def": return .def
                case "extern": return .extern
                case "if": return .if
                case "then": return .then
                case "else": return .else
                default: return .identifier(str)
            }
        }
        
        return nil
        
    }
    
    func lex() -> [Token] {
        var toks = [Token]()
        while let tok = advanceToNextToken() {
            toks.append(tok)
        }
        return toks
    }

}

