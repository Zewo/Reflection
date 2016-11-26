extension AnyExtensions {
    
    mutating func mutableStorage() -> UnsafeMutableRawPointer {
        return Reflection.mutableStorage(instance: &self)
    }
    
    mutating func storage() -> UnsafeRawPointer {
        return Reflection.storage(instance: &self)
    }
    
}

func mutableStorage<T>(instance: inout T) -> UnsafeMutableRawPointer {
    return UnsafeMutableRawPointer(mutating: storage(instance: &instance))
}

func storage<T>(instance: inout T) -> UnsafeRawPointer {
    return withUnsafePointer(to: &instance) { pointer in
        if type(of: instance) is AnyClass {
            return UnsafeRawPointer(bitPattern: UnsafePointer<Int>(pointer).pointee)!
        } else {
            return UnsafeRawPointer(pointer)
        }
    }
}
