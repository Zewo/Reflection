//
//  Storage.swift
//  Reflection
//
//  Created by Bradley Hilton on 3/17/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

func mutableStorageForInstance(_ instance: inout Any) -> UnsafeMutablePointer<Int> {
    return UnsafeMutablePointer<Int>(storageForInstance(&instance))
}

func storageForInstance(_ instance: inout Any) -> UnsafePointer<Int> {
    return withUnsafePointer(&instance) { pointer in
        if instance is AnyObject {
            return UnsafePointer<Int>(bitPattern: UnsafePointer<Int>(pointer).pointee)!.advanced(by: 2)
        } else if wordSizeForType(instance.dynamicType) <= 3 {
            return UnsafePointer<Int>(pointer)
        } else {
            return UnsafePointer<Int>(bitPattern: UnsafePointer<Int>(pointer).pointee)!
        }
    }
}

func mutableStorageForInstance<T>(_ instance: inout T) -> UnsafeMutablePointer<Int> {
    return UnsafeMutablePointer<Int>(storageForInstance(&instance))
}

func storageForInstance<T>(_ instance: inout T) -> UnsafePointer<Int> {
    return withUnsafePointer(&instance) { pointer in
        if instance is AnyObject {
            return UnsafePointer<Int>(bitPattern: UnsafePointer<Int>(pointer).pointee)!.advanced(by: 2)
        } else {
            return UnsafePointer<Int>(pointer)
        }
    }
}
