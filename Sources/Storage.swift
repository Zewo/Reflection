
func mutableStorageForInstance(_ instance: inout Any) -> UnsafeMutablePointer<UInt8> {
    return UnsafeMutablePointer(storageForInstance(&instance))
}

func storageForInstance(_ instance: inout Any) -> UnsafePointer<UInt8> {
    return withUnsafePointer(&instance) { pointer in
        if instance is AnyObject {
            return UnsafePointer(bitPattern: UnsafePointer<Int>(pointer).pointee)!
        } else if sizeofValue(instance) <= 3 * sizeof(Int) {
            return UnsafePointer(pointer)
        } else {
            return UnsafePointer(bitPattern: UnsafePointer<Int>(pointer).pointee)!
        }
    }
}

func mutableStorageForInstance<T>(_ instance: inout T) -> UnsafeMutablePointer<UInt8> {
    return UnsafeMutablePointer(storageForInstance(&instance))
}

func storageForInstance<T>(_ instance: inout T) -> UnsafePointer<UInt8> {
    return withUnsafePointer(&instance) { pointer in
        if instance is AnyObject {
            return UnsafePointer(bitPattern: UnsafePointer<Int>(pointer).pointee)!
        } else {
            return UnsafePointer(pointer)
        }
    }
}
