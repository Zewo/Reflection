//
//  ValueSetters.swift
//  Allegro
//
//  Created by Bradley Hilton on 3/17/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

/// Set value for key of an instance
public func setValue(value: Any, forKey key: String, inout ofInstance instance: Any) throws {
    let field = try fieldForType(instance.dynamicType, withName: key)
    try setValue(value, forKey: key, field: field, storage: mutableStorageForInstance(&instance))
}

/// Set value for key of an instance
public func setValue(value: Any, forKey key: String, ofInstance instance: AnyObject) throws {
    var copy: Any = instance
    try setValue(value, forKey: key, ofInstance: &copy)
}

/// Set value for key of an instance
public func setValue<T>(value: Any, forKey key: String, inout ofInstance instance: T) throws {
    let field = try fieldForType(T.self, withName: key)
    try setValue(value, forKey: key, field: field, storage: mutableStorageForInstance(&instance))
}

private func fieldForType(type: Any.Type, withName name: String) throws -> Field {
    guard let field = try fieldsForType(type).filter({ $0.name == name }).first else { throw Error.InstanceHasNoKey(type: type, key: name) }
    return field
}

private func setValue(value: Any, forKey key: String, field: Field, storage: UnsafeMutablePointer<Int>) throws {
    var storage = storage.advancedBy(field.offset)
    guard instanceValue(value, isOfType: field.type) else { throw Error.ValueIsNotOfType(value: value, type: field.type) }
    var copy: Any = value
    storage.consumeBuffer(bufferForInstance(&copy))
}
