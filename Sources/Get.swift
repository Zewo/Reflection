
/// Get value for key from instance
public func get(_ key: String, from instance: Any) throws -> Any {
    for property in try properties(instance) {
        if property.key == key {
            return property.value
        }
    }
    throw Error.instanceHasNoKey(type: instance.dynamicType, key: key)
}

/// Get value for key from instance as type `T`
public func get<T>(_ key: String, from instance: Any) throws -> T {
    let any: Any = try get(key, from: instance)
    guard let value = any as? T else {
        throw Error.valueIsNotType(value: any, type: T.self)
    }
    return value
}
