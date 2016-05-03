//
//  TypeConstructor.swift
//  Allegro
//
//  Created by Bradley Hilton on 3/17/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

public protocol Initializable : class {
    init()
}

/// Create a class or struct with a constructor method. Return a value of `field.type` for each field. Classes must conform to `Initializable`.
public func constructType<T>(constructor: Field throws -> Any) throws -> T {
    guard case _? = Metadata(type: T.self).nominalType else { throw Error.NotStructOrClass(type: T.self) }
    if Metadata(type: T.self)?.kind == .Struct {
        return try constructValueType(constructor)
    } else if let initializable = T.self as? Initializable.Type {
        return try constructReferenceType(initializable.init() as! T, constructor: constructor)
    } else {
        throw Error.ClassNotInitializable(type: T.self)
    }
}

private func constructValueType<T>(constructor: Field throws -> Any) throws -> T {
    guard Metadata(type: T.self)?.kind == .Struct else { throw Error.NotStructOrClass(type: T.self) }
    let pointer = UnsafeMutablePointer<T>.alloc(1)
    defer { pointer.dealloc(1) }
    var storage = UnsafeMutablePointer<Int>(pointer)
    var values = [Any]()
    try constructType(&storage, values: &values, fields: fieldsForType(T.self), constructor: constructor)
    return pointer.memory
}

private func constructReferenceType<T>(value: T, constructor: Field throws -> Any) throws -> T {
    var copy = value
    var storage = mutableStorageForInstance(&copy)
    var values = [Any]()
    try constructType(&storage, values: &values, fields: fieldsForType(T.self), constructor: constructor)
    return copy
}

private func constructType(inout storage: UnsafeMutablePointer<Int>, inout values: [Any], fields: [Field], constructor: Field throws -> Any) throws {
    for field in fields {
        var value = try constructor(field)
        guard instanceValue(value, isOfType: field.type) else { throw Error.ValueIsNotOfType(value: value, type: field.type) }
        values.append(value)
        storage.consumeBuffer(bufferForInstance(&value))
    }
}

/// Create a class or struct from a dictionary. Classes must conform to `Initializable`.
public func constructType<T>(dictionary: [String: Any]) throws -> T {
    return try constructType(constructorForDictionary(dictionary))
}

private func constructorForDictionary(dictionary: [String: Any]) -> Field throws -> Any {
    return { field in
        if let value = dictionary[field.name] {
            return value
        } else if let nilLiteralConvertible = field.type as? NilLiteralConvertible.Type {
            return nilLiteralConvertible.init(nilLiteral: ())
        } else {
            throw Error.RequiredValueMissing(key: field.name)
        }
    }
}
