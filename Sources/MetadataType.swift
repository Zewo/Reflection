//
//  MetadataType.swift
//  Reflection
//
//  Created by Bradley Hilton on 5/4/16.
//  Copyright © 2016 Zewo. All rights reserved.
//

protocol MetadataType : PointerType {
    static var kind: Metadata.Kind? { get }
}

extension MetadataType {
    
    var valueWitnessTable: ValueWitnessTable {
        return ValueWitnessTable(pointer: UnsafePointer<UnsafePointer<Int>>(pointer).advanced(by: -1).pointee)
    }
    
    var kind: Metadata.Kind {
        return Metadata.Kind(flag: UnsafePointer<Int>(pointer).pointee)
    }
    
    init?(type: Any.Type) {
        self.init(pointer: unsafeBitCast(type, to: UnsafePointer<Int>.self))
        if let kind = self.dynamicType.kind where kind != self.kind {
            return nil
        }
    }
    
}
