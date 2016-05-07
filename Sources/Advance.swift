//
//  Advance.swift
//  Reflection
//
//  Created by Bradley Hilton on 5/4/16.
//  Copyright © 2016 Zewo. All rights reserved.
//

extension Strideable {
    
    mutating func advance() {
        self = advanced(by: 1)
    }
    
}
