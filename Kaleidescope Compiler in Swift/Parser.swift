//
//  Parser.swift
//  Kaleidoscope Compiler in Swift
//
//  Created by Ivan Minier on 5/27/17.
//  Copyright © 2017 Ivan Minier. All rights reserved.
//
import Foundation
import Darwin

class Parser {
    let tokens: [Token]
    var index = 0
    
    init (tokens: [Token]) {
        self.tokens = tokens
    }
    
    var currentToken: Token? {
        return index < tokens.count ? tokens[index] : nil
    }
    
    func consumeToken(n: Int = 1) {
        index += n
    }
    
    func advance() {
        index +=  1
    }
    
    func parseIdentifier() throws -> String {
        guard let token = currentToken else {
            throw ParseError.unexpectedEOF
        }
        
        guard case .identifier(let name) = token else {
            throw ParseError.unexpectedToken(token)
        }
        advance()
        return name
    }
    
    func parseCommaSeparated<TermType>(_ parseFn: () throws -> TermType) throws -> [TermType] {
        try parse(.leftParen)
        var vals = [TermType]()
        while let tok = currentToken, tok != .rightParen {
            let val = try parseFn()
            if case .comma? = currentToken {
                try parse(.comma)
            }
            vals.append(val)
        }
        try parse(.rightParen)
        return vals
    }
    
    func parsePrototype() throws -> Prototype {
        let name = try parseIdentifier()
        let params = try parseCommaSeparated(parseIdentifier)
        return Prototype(name: name, params: params)
    }
    
    func parseExtern() throws -> Prototype {
        try parse(.extern)
        let proto = try parsePrototype()
        try parse(.semicolon)
        return proto
    }
    
    func parseDefinition() throws -> Definition {
        try parse(.def)
        let prototype = try parsePrototype()
        let expr = try parseExpr()
        let def = Definition(prototype: prototype, expr: expr)
        try parse(.semicolon)
        return def
    }
    
    func parseFile() throws -> File {
        let file = File()
        while let tok = currentToken {
            switch tok {
            case .extern:
                file.addExtern(try parseExtern())
            case .def:
                file.addDefinition(try parseDefinition())
            default:
                let expr = try parseExpr()
                try consume(.semicolon)
                file.addExpression(expr)
            }
        }
        return file
    }
    
    func parseExpr() throws -> Expr {
        guard let token = currentToken else {
            throw ParseError.unexpectedEOF
        }
        var expr: Expr
        switch token {
        case .leftParen:
            consumeToken()
            expr = try parseExpr()
            try consume(.rightParen)
        case .number(let value):
            consumeToken()
            expr = .number(value)
        case .identifier(let value):
            consumeToken()
            if case .leftParen? = currentToken {
                let params = try parseCommaSeparated(parseExpr)
                expr = .call(value, params)
            } else {
                expr = .variable(value)
            }
        case .if:
            consumeToken()
            let cond = try parseExpr()
            let consume(.then)
            let thenVal = try parseExpr()
            try consume(.else)
            let elseVal = try parseExpr()
            expr = .ifelse(cond, thenVal, elseVal)
        default:
            throw ParseError.unexpectedToken(token)
        }
        
        if case .operator(let op)? = currentToken {
            consumeToken()
            let rhs = try parseExpr()
            expr = .binary(expr, op, rhs)
        }
        
        return expr
    }
    
    func consume(_ token: Token) throws {
        guard let tok = currentToken else {
            throw ParseError.unexpectedEOF
        }
        guard token == tok else {
            throw ParseError.unexpectedToken(token)
        }
        consumeToken()
    }
    
    func parse(_ token: Token) throws {
        guard let tok = currentToken else {
            throw ParseError.unexpectedEOF
        }
        
        guard token == tok else {
            throw ParseError.unexpectedToken(token)
        }
        
        advance()
    }

    
}
