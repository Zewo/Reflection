//
//  Allegro.swift
//  Allegro
//
//  Created by Bradley Hilton on 1/26/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

/// Represents a type field
public struct Field {
    public let name: String
    public let type: Any.Type
    let offset: Int
}

/// Retrieve the fields for `type`
public func fieldsForType(type: Any.Type) throws -> [Field] {
    guard let nominalType = Metadata(type: type).nominalType else {
        throw Error.NotStructOrClass(type: type)
    }
    let fieldNames = nominalType.nominalTypeDescriptor.fieldNames
    let fieldTypes = nominalType.fieldTypes ?? []
    var offset = 0
    return (0..<nominalType.nominalTypeDescriptor.numberOfFields).map { i in
        defer { offset += wordSizeForType(fieldTypes[i]) }
        return Field(name: fieldNames[i], type: fieldTypes[i], offset: offset)
    }
}

