//
//  main.swift
//  Kaleidoscope Compiler in Swift
//
//  Created by Ivan Minier on 5/27/17.
//  Copyright © 2017 Ivan Minier. All rights reserved.
//

import Darwin

let toks = Lexer(input: "def foo(n) (n * 100.34);").lex()
print(toks)
