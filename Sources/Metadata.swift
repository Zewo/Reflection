//
//  Metadata.swift
//  Allegro
//
//  Created by Bradley Hilton on 3/4/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

private var is64BitPlatform: Bool {
    return sizeof(Int) == sizeof(Int64)
}

protocol MetadataType {
    static var requiredKind: Metadata.Kind? { get }
    var pointer: UnsafePointer<Int> { get }
}

extension MetadataType {

    static var requiredKind: Metadata.Kind? {
        return nil
    }
    
    var valueWitnessTable: ValueWitnessTable {
        return ValueWitnessTable(pointer: UnsafePointer<Int>(bitPattern: pointer[-1]))
    }
    
    var kind: Metadata.Kind {
        return Metadata.Kind(flag: pointer[0])
    }
    
    init?(type: Any.Type) {
        func cast<T>(type: Any.Type) -> T {
            return unsafeBitCast(type, T.self)
        }
        self = cast(type)
        if let requiredKind = self.dynamicType.requiredKind {
            guard kind == requiredKind else {
                return nil
            }
        }
    }
    
}

func instanceValue(instance: Any, isOfType type: Any.Type) -> Bool {
    if instance.dynamicType == type {
        return true
    }
    guard var subclass = Metadata.Class(type: instance.dynamicType), let superclass = Metadata.Class(type: type) else {
        return false
    }
    while let parentClass = subclass.superclass {
        if parentClass == superclass {
            return true
        }
        subclass = parentClass
    }
    return false
}

func ==(lhs: Any.Type, rhs: Any.Type) -> Bool {
    return Metadata(type: lhs) == Metadata(type: rhs)
}

func ==(lhs: MetadataType, rhs: MetadataType) -> Bool {
    return lhs.pointer == rhs.pointer
}

protocol NominalType : MetadataType {
    var nominalTypeDescriptor: NominalTypeDescriptor { get }
}

extension NominalType {
    
    var fieldTypes: [Any.Type]? {
        guard let function = nominalTypeDescriptor.fieldTypesAccessor else { return nil }
        return (0..<nominalTypeDescriptor.numberOfFields).map {
            unsafeBitCast(function(pointer).advancedBy($0).memory, Any.Type.self)
        }
    }
    
}

struct Metadata : MetadataType {
    
    let pointer: UnsafePointer<Int>
    
    init(type: Any.Type) {
        self = unsafeBitCast(type, Metadata.self)
    }
    
    enum Kind {
        case Struct
        case Class
        case Other
        init(flag: Int) {
            switch flag {
            case 1: self = .Struct
            case let x where x > 4096: self = .Class
            default: self = .Other
            }
        }
    }
    
    var metadataType: MetadataType? {
        switch kind {
        case .Struct: return unsafeBitCast(self, Struct.self)
        case .Class: return unsafeBitCast(self, Class.self)
        default: return nil
        }
    }
    
    var nominalType: NominalType? {
        switch kind {
        case .Struct: return unsafeBitCast(self, Struct.self)
        case .Class: return unsafeBitCast(self, Class.self)
        default: return nil
        }
    }
    
    struct Struct : NominalType {
        
        static var requiredKind = Kind.Struct
        
        let pointer: UnsafePointer<Int>
        
        var nominalTypeDescriptor: NominalTypeDescriptor {
            return NominalTypeDescriptor(pointer: UnsafePointer(bitPattern: pointer[1]))
        }
        
    }
    
    struct Class : NominalType {
        
        static var requiredKind = Kind.Class
        
        let pointer: UnsafePointer<Int>
        
        var superclass: Class? {
            return pointer[1] != 0 ? Class(pointer: UnsafePointer<Int>(bitPattern: pointer[1])) : nil
        }
        
        var nominalTypeDescriptor: NominalTypeDescriptor {
            return NominalTypeDescriptor(pointer: UnsafePointer(bitPattern: pointer[is64BitPlatform ? 8 : 11]))
        }
        
    }
    
}

// https://github.com/apple/swift/blob/40867560fd4229bfac812eda2a05c279faa76753/lib/IRGen/ValueWitness.h
struct ValueWitnessTable {
    
    let pointer: UnsafePointer<Int>
    
    var size: Int {
        return pointer[17]
    }
    
    var stride: Int {
        return pointer[19]
    }
    
}

struct NominalTypeDescriptor {
    
    let pointer: UnsafePointer<Int>
    
    enum Kind : Int {
        case Class, Struct
    }
    
    var kind: Kind? {
        return Kind(rawValue: pointer[0])
    }
    
    var mangledName: String? {
        return String.fromCString(UnsafePointer<CChar>(bitPattern: pointer[1]))
    }
    
    var numberOfFields: Int {
        return Int(UnsafePointer<Int8>(pointer.advancedBy(2)).memory)
    }
    
    var fieldNames: [String] {
        var pointer = UnsafePointer<CChar>(bitPattern: self.pointer[is64BitPlatform ? 3 : 4])
        return (0..<numberOfFields).map { _ in
            defer {
                while pointer.memory != 0 {
                    pointer.advance()
                }
                pointer.advance()
            }
            return String.fromCString(pointer) ?? ""
        }
    }
    
    typealias FieldsTypeAccessor = @convention(c) UnsafePointer<Int> -> UnsafePointer<UnsafePointer<Int>>
    
    var fieldTypesAccessor: FieldsTypeAccessor? {
        return UnsafePointer<FieldsTypeAccessor?>(pointer.advancedBy(is64BitPlatform ? 4 : 5)).memory
    }
    
}

struct AnyExistentialContainer {
    
    var buffer: (Int, Int, Int)
    var type: Any.Type
    
    init(type: Any.Type, pointer: UnsafePointer<Int>) {
        self.type = type
        if wordSizeForType(type) <= 3 {
            self.buffer = UnsafePointer<(Int, Int, Int)>(pointer).memory
        } else {
            self.buffer = (pointer.hashValue, 0, 0)
        }
    }
    
    var any: Any {
        return unsafeBitCast(self, Any.self)
    }
    
}

