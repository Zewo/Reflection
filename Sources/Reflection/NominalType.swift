protocol NominalType : MetadataType {
    var nominalTypeDescriptor: NominalTypeDescriptor { get }
}

extension NominalType {
    
    func fieldNamesAndTypes(for type: Any.Type) -> [(String, Any.Type)]? {
        return (0..<nominalTypeDescriptor.numberOfFields).map { index in
            var context: (String, Any.Type) = ("", Any.self)
            getFieldAt(type, index, { name, type, context in
                let context = context.assumingMemoryBound(to: (String, Any.Type).self)
                context.pointee = (
                    String(cString: name),
                    unsafeBitCast(type, to: Any.Type.self)
                )
            }, &context)
            return context
        }
    }

    var fieldOffsets: [Int]? {
        let vectorOffset = nominalTypeDescriptor.fieldOffsetVector
        guard vectorOffset != 0 else { return nil }
        return (0..<nominalTypeDescriptor.numberOfFields).map {
            return Int(UnsafePointer<Int32>(pointer)[vectorOffset + $0 + (is64BitPlatform ? 2 : 0)])
        }
    }
    
}

@_silgen_name("swift_getFieldAt")
private func getFieldAt(
    _ type: Any.Type,
    _ index: Int,
    _ callback: @convention(c) (
        _ mangledName: UnsafePointer<CChar>,
        _ type: UnsafeRawPointer,
        _ context: UnsafeMutableRawPointer
    ) -> Void,
    _ context: UnsafeMutableRawPointer
)
