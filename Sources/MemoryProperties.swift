
public func alignof(_ x: Any.Type) -> Int {
    return Metadata(type: x).valueWitnessTable.align
}

public func sizeof(_ x: Any.Type) -> Int {
    return Metadata(type: x).valueWitnessTable.size
}

public func strideof(_ x: Any.Type) -> Int {
    return Metadata(type: x).valueWitnessTable.stride
}

public func alignofValue(_ x: Any) -> Int {
    return alignof(x.dynamicType)
}

public func sizeofValue(_ x: Any) -> Int {
    return sizeof(x.dynamicType)
}

public func strideofValue(_ x: Any) -> Int {
    return strideof(x.dynamicType)
}

