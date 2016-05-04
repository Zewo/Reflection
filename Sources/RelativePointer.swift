//
//  RelativePointer.swift
//  Reflection
//
//  Created by Bradley Hilton on 5/3/16.
//  Copyright © 2016 Zewo. All rights reserved.
//

func relativePointer<T, U, V where U : Integer>(base: UnsafePointer<T>, offset: U) -> UnsafePointer<V> {
    return UnsafePointer(UnsafePointer<Int8>(base).advanced(by: Int(integer: offset)))
}

extension Int {
    
    private init<T : Integer>(integer: T) {
        switch integer {
        case let value as Int: self = value
        case let value as Int32: self = Int(value)
        case let value as Int16: self = Int(value)
        case let value as Int8: self = Int(value)
        default: self = 0
        }
    }
    
}
