struct HashedType : Hashable {
    let hashValue: Int
    init(_ type: Any.Type) {
        hashValue = unsafeBitCast(type, to: Int.self)
    }
    init<T>(_ pointer: UnsafePointer<T>) {
        hashValue = pointer.hashValue
    }
}

func == (lhs: HashedType, rhs: HashedType) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

private var cachedProperties = [HashedType : Array<Property.Description>]()

/// An instance property
public struct Property {
    public let key: String
    public let value: Any

    /// An instance property description
    public struct Description {
        public let key: String
        public let type: Any.Type
        let offset: Int
        func write(_ value: Any, to storage: UnsafeMutableRawPointer) throws {
            return try extensions(of: type).write(value, to: storage.advanced(by: offset))
        }
    }
}

/// Retrieve properties for `instance`
public func properties(_ instance: Any) throws -> [Property] {
    let props = try properties(type(of: instance))
    var copy = extensions(of: instance)
    let storage = copy.storage()
    return props.map { nextProperty(description: $0, storage: storage) }
}

private func nextProperty(description: Property.Description, storage: UnsafeRawPointer) -> Property {
    return Property(
        key: description.key,
        value: extensions(of: description.type).value(from: storage.advanced(by: description.offset))
    )
}

/// Retrieve property descriptions for `type`
public func properties(_ type: Any.Type) throws -> [Property.Description] {
    let hashedType = HashedType(type)
    if let properties = cachedProperties[hashedType] {
        return properties
    } else if let nominalType = Metadata.Struct(type: type) {
        return try fetchAndSaveProperties(nominalType: nominalType, hashedType: hashedType, anyType: type)
    } else {
        throw ReflectionError.notStruct(type: type)
    }
}

func fetchAndSaveProperties<T : NominalType>(nominalType: T, hashedType: HashedType, anyType: Any.Type) throws -> [Property.Description] {
    let properties = try propertiesForNominalType(nominalType: nominalType, anyType: anyType)
    cachedProperties[hashedType] = properties
    return properties
}

private func propertiesForNominalType<T : NominalType>(nominalType: T, anyType: Any.Type) throws -> [Property.Description] {
    guard nominalType.nominalTypeDescriptor.numberOfFields != 0 else { return [] }
    guard let fieldNamesAndTypes = nominalType.fieldNamesAndTypes(for: anyType), let fieldOffsets = nominalType.fieldOffsets else {
        throw ReflectionError.unexpected
    }
    let fieldNames = fieldNamesAndTypes.map { $0.0 }
    let fieldTypes = fieldNamesAndTypes.map { $0.1 }
    return (0..<nominalType.nominalTypeDescriptor.numberOfFields).map { i in
        return Property.Description(key: fieldNames[i], type: fieldTypes[i], offset: fieldOffsets[i])
    }
}
