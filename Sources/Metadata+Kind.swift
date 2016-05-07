//
//  Metadata+Kind.swift
//  Reflection
//
//  Created by Bradley Hilton on 5/4/16.
//  Copyright © 2016 Zewo. All rights reserved.
//

//https://github.com/apple/swift/blob/swift-3.0-branch/utils/dtrace/runtime.d

extension Metadata {
    
    static let kind: Kind? = nil
    
    enum Kind {
        case Struct
        case Enum
        case Opaque
        case Tuple
        case Function
        case Existential
        case Metatype
        case ObjCClassWrapper
        case HeapLocalVariable
        case HeapArray
        case Class
        init(flag: Int) {
            switch flag {
            case 1: self = .Struct
            case 2: self = .Enum
            case 8: self = .Opaque
            case 9: self = .Tuple
            case 10: self = .Function
            case 12: self = .Existential
            case 13: self = .Metatype
            case 14: self = .ObjCClassWrapper
            case 64: self = .HeapLocalVariable
            case 65: self = .HeapArray
            default: self = .Class
            }
        }
    }
    
}


