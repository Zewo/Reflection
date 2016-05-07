
/// Set value for key of an instance
public func set(_ value: Any, key: String, for instance: inout Any) throws {
    let property = try propertyForType(instance.dynamicType, withName: key)
    try setValue(value, forKey: key, property: property, storage: mutableStorageForInstance(&instance))
}

/// Set value for key of an instance
public func set(_ value: Any, key: String, for instance: AnyObject) throws {
    var copy: Any = instance
    try set(value, key: key, for: &copy)
}

/// Set value for key of an instance
public func set<T>(_ value: Any, key: String, for instance: inout T) throws {
    let property = try propertyForType(T.self, withName: key)
    try setValue(value, forKey: key, property: property, storage: mutableStorageForInstance(&instance))
}

private func propertyForType(_ type: Any.Type, withName key: String) throws -> Property.Description {
    guard let property = try properties(type).filter({ $0.key == key }).first else { throw Error.instanceHasNoKey(type: type, key: key) }
    return property
}

private func setValue(_ value: Any, forKey key: String, property: Property.Description, storage: UnsafeMutablePointer<Int>) throws {
    var storage = storage.advanced(by: property.offset)
    guard Reflection.value(value, is: property.type) else { throw Error.valueIsNotType(value: value, type: property.type) }
    var copy: Any = value
    storage.consumeBuffer(bufferForInstance(&copy))
}
