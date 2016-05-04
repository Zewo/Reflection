//
//  Metadata.swift
//  Reflection
//
//  Created by Bradley Hilton on 3/4/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

struct Metadata : MetadataType {
    
    var pointer: UnsafePointer<Int>
    
    init(type: Any.Type) {
        self.init(pointer: unsafeBitCast(type, to: UnsafePointer<Int>.self))
    }
    
    var isStructOrClass: Bool {
        return kind == .Struct || kind == .Class
    }
    
}

struct _Metadata {}

var is64BitPlatform: Bool {
    return sizeof(Int) == sizeof(Int64)
}
