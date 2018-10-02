struct NominalTypeDescriptor : PointerType {
    typealias Pointee = _NominalTypeDescriptor
    
    var pointer: UnsafePointer<_NominalTypeDescriptor>

    var mangledName: String {
        return String(
            cString: relativePointer(base: pointer, offset: pointer.pointee.mangledName) as UnsafePointer<UInt8>
        )
    }

    var numberOfFields: Int {
        return Int(pointer.pointee.numberOfFields)
    }

    var fieldOffsetVector: Int {
        return Int(pointer.pointee.fieldOffsetVector)
    }

}

struct _NominalTypeDescriptor {
    var property1: Int32
    var property2: Int32
    var mangledName: Int32
    var property4: Int32
    var numberOfFields: Int32
    var fieldOffsetVector: Int32
}
