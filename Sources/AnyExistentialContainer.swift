
struct AnyExistentialContainer {

    var buffer: (Int, Int, Int)
    var type: Any.Type

    init(type: Any.Type, pointer: UnsafePointer<Int>) {
        self.type = type
        if wordSizeForType(type) <= 3 {
            self.buffer = UnsafePointer<(Int, Int, Int)>(pointer).pointee
        } else {
            self.buffer = (pointer.hashValue, 0, 0)
        }
    }

    var any: Any {
        return unsafeBitCast(self, to: Any.self)
    }

}
