
func bufferForInstance(_ instance: inout Any) -> UnsafeBufferPointer<Int> {
    let size = wordSizeForType(instance.dynamicType)
    let pointer: UnsafePointer<Int> = withUnsafePointer(&instance) { pointer in
        if size <= 3 {
            return UnsafePointer<Int>(pointer)
        } else {
            return UnsafePointer<Int>(bitPattern: UnsafePointer<Int>(pointer)[0])!
        }
    }
    return UnsafeBufferPointer(start: pointer, count: size)
}

extension UnsafeMutablePointer {
    
    mutating func consumeBuffer(_ buffer: UnsafeBufferPointer<Int>) {
        var pointer = UnsafeMutablePointer<Int>(self)
        buffer.forEach {
            pointer.pointee = $0
            pointer.advance()
        }
        self = UnsafeMutablePointer(pointer)
    }
    
}

func wordSizeForType(_ type: Any.Type) -> Int {
    let size = Metadata(type: type).valueWitnessTable.size
    return (size / sizeof(Int)) + (size % sizeof(Int) == 0 ? 0 : 1)
}