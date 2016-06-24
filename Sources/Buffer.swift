
func buffer(instance: inout Any) -> UnsafeBufferPointer<UInt8> {
    let size = sizeofValue(instance)
    let pointer: UnsafePointer<UInt8> = withUnsafePointer(&instance) { pointer in
        if size <= 3 * sizeof(Int) {
            return UnsafePointer(pointer)
        } else {
            return UnsafePointer(bitPattern: UnsafePointer<Int>(pointer)[0])!
        }
    }
    return UnsafeBufferPointer(start: pointer, count: size)
}

extension UnsafeMutablePointer {
    
    func consume(buffer: UnsafeBufferPointer<UInt8>) {
        let pointer = UnsafeMutablePointer<UInt8>(self)
        for (i, byte) in buffer.enumerated() {
            pointer[i] = byte
        }
    }
    
}
