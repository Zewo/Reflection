//
//  Metadata+Struct.swift
//  Reflection
//
//  Created by Bradley Hilton on 5/4/16.
//  Copyright © 2016 Zewo. All rights reserved.
//

extension Metadata {
    
    struct Struct : NominalType {
        static let kind: Kind? = .Struct
        var pointer: UnsafePointer<_Metadata._Struct>
        var nominalTypeDescriptorOffsetLocation: Int {
            return 1
        }
    }
    
}

extension _Metadata {
    
    struct _Struct {
        var kind: Int
        var nominalTypeDescriptorOffset: Int
        var parent: Metadata?
    }
    
}


