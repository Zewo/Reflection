
/// An instance property
public struct Property {
    
    public let key: String
    public let value: Any
    
    /// An instance property description
    public struct Description {
        public let key: String
        public let type: Any.Type
        let offset: Int
    }
    
}

/// Retrieve properties for `instance`
public func properties(_ instance: Any) throws -> [Property] {
    let properties = try Reflection.properties(instance.dynamicType)
    var copy = instance
    var storage = storageForInstance(&copy)
    return properties.map { nextPropertyForDescription($0, pointer: &storage) }
}

/// Retrieve property descriptions for `type`
public func properties(_ type: Any.Type) throws -> [Property.Description] {
    if let nominalType = Metadata.Struct(type: type) {
        return try propertiesForNominalType(nominalType)
    } else if let nominalType = Metadata.Class(type: type) {
        return try propertiesForNominalType(nominalType)
    } else {
        throw Error.notStructOrClass(type: type)
    }
}

private func nextPropertyForDescription(_ description: Property.Description, pointer: inout UnsafePointer<Int>) -> Property {
    defer { pointer = pointer.advanced(by: wordSizeForType(description.type)) }
    return Property(key: description.key, value: AnyExistentialContainer(type: description.type, pointer: pointer).any)
}

private func propertiesForNominalType<T : NominalType>(_ type: T) throws -> [Property.Description] {
    guard type.nominalTypeDescriptor.numberOfFields != 0 else { return [] }
    guard let fieldTypes = type.fieldTypes, let fieldOffsets = type.fieldOffsets else {
        throw Error.unexpected
    }
    let fieldNames = type.nominalTypeDescriptor.fieldNames
    return (0..<type.nominalTypeDescriptor.numberOfFields).map { i in
        return Property.Description(key: fieldNames[i], type: fieldTypes[i], offset: fieldOffsets[i])
    }
}
