protocol NominalType : MetadataType {
    var nominalTypeDescriptor: NominalTypeDescriptor { get }
}

extension NominalType {

    var fieldTypes: [Any.Type]? {
        guard let function = nominalTypeDescriptor.fieldTypesAccessor else { return nil }
        return (0..<nominalTypeDescriptor.numberOfFields).map {
            return unsafeBitCast(function(UnsafePointer<Int>(pointer)).advanced(by: $0).pointee, to: Any.Type.self)
        }
    }

    var fieldOffsets: [Int]? {
        let vectorOffset = nominalTypeDescriptor.fieldOffsetVector
        guard vectorOffset != 0 else { return nil }
        return (0..<nominalTypeDescriptor.numberOfFields).map {
            return UnsafePointer<Int>(pointer)[vectorOffset + $0]
        }
    }
}
