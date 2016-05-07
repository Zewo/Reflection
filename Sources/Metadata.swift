
struct Metadata : MetadataType {
    
    var pointer: UnsafePointer<Int>
    
    init(type: Any.Type) {
        self.init(pointer: unsafeBitCast(type, to: UnsafePointer<Int>.self))
    }
    
    var isStructOrClass: Bool {
        return kind == .struct || kind == .class
    }
    
}

struct _Metadata {}

var is64BitPlatform: Bool {
    return sizeof(Int) == sizeof(Int64)
}
