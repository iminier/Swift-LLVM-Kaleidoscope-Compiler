//
//  Expr.swift
//  Kaleidoscope Compiler in Swift
//
//  Created by Ivan Minier on 5/27/17.
//  Copyright © 2017 Ivan Minier. All rights reserved.
//

indirect enum Expr {
    case number(Double)
    case variable(String)
    case binary(Expr, BinaryOperator, Expr)
    case call(String, [Expr])
    case ifelse(Expr, Expr, Expr)
}
