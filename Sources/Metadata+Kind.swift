//
//  Metadata+Kind.swift
//  Reflection
//
//  Created by Bradley Hilton on 5/4/16.
//  Copyright © 2016 Zewo. All rights reserved.
//

extension Metadata {
    
    static let kind: Kind? = nil
    
    enum Kind {
        case Struct
        case Class
        case Other
        init(flag: Int) {
            switch flag {
            case 1: self = .Struct
            case let x where x > 4096: self = .Class
            default: self = .Other
            }
        }
    }
    
}


