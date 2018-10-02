extension Metadata {
    struct Class : NominalType {

        static let kind: Kind? = .class
        var pointer: UnsafePointer<_Metadata._Class>
        
        var nominalTypeDescriptor: NominalTypeDescriptor {
            return pointer.withMemoryRebound(to: NominalTypeDescriptor.self, capacity: 15, { $0[nominalTypeDescriptorLocation] })
        }

        var nominalTypeDescriptorLocation: Int {
            return is64BitPlatform ? 8 : 11
        }

        var superclass: Class? {
            guard let superclass = pointer.pointee.superclass else { return nil }
            return Metadata.Class(type: superclass)
        }
        
        func properties(anyType: Any.Type) throws -> [Property.Description] {
            let properties = try fetchAndSaveProperties(nominalType: self, hashedType: HashedType(pointer), anyType: anyType)
            guard let superclass = superclass, String(describing: unsafeBitCast(superclass.pointer, to: Any.Type.self)) != "SwiftObject" else {
                return properties
            }
            return try superclass.properties(anyType: anyType) + properties
        }

    }
}

extension _Metadata {
    struct _Class {
        var kind: Int
        var superclass: Any.Type?
    }
}
