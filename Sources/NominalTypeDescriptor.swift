
struct NominalTypeDescriptor : PointerType {
    
    var pointer: UnsafePointer<_NominalTypeDescriptor>
    
    var mangledName: String {
        return String(cString: relativePointer(base: pointer, offset: pointer.pointee.mangledName))
    }
    
    var numberOfFields: Int {
        return Int(pointer.pointee.numberOfFields)
    }
    
    var fieldOffsetVector: Int {
        return Int(pointer.pointee.fieldOffsetVector)
    }
    
    var fieldNames: [String] {
        var pointer: UnsafePointer<CChar> = relativePointer(base: UnsafePointer<Int32>(self.pointer).advanced(by: 3), offset: self.pointer.pointee.fieldNames)
        return (0..<numberOfFields).map { _ in
            defer {
                while pointer.pointee != 0 {
                    pointer.advance()
                }
                pointer.advance()
            }
            return String.init(validatingUTF8: pointer) ?? ""
        }
    }
    
    typealias FieldsTypeAccessor = @convention(c) UnsafePointer<Int> -> UnsafePointer<UnsafePointer<Int>>
    
    var fieldTypesAccessor: FieldsTypeAccessor? {
        let offset = pointer.pointee.fieldTypesAccessor
        guard offset != 0 else { return nil }
        let offsetPointer: UnsafePointer<Int> = relativePointer(base: UnsafePointer<Int32>(self.pointer).advanced(by: 4), offset: offset)
        return unsafeBitCast(offsetPointer, to: FieldsTypeAccessor.self)
    }
    
}

struct _NominalTypeDescriptor {
    
    var mangledName: Int32
    var numberOfFields: Int32
    var fieldOffsetVector: Int32
    var fieldNames: Int32
    var fieldTypesAccessor: Int32
    
}
