//
//  Storage.swift
//  Allegro
//
//  Created by Bradley Hilton on 3/17/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

func mutableStorageForInstance(inout instance: Any) -> UnsafeMutablePointer<Int> {
    return UnsafeMutablePointer<Int>(storageForInstance(&instance))
}

func storageForInstance(inout instance: Any) -> UnsafePointer<Int> {
    return withUnsafePointer(&instance) { pointer in
        if instance is AnyObject {
            return UnsafePointer<Int>(bitPattern: UnsafePointer<Int>(pointer).memory).advancedBy(2)
        } else if wordSizeForType(instance.dynamicType) <= 3 {
            return UnsafePointer<Int>(pointer)
        } else {
            return UnsafePointer<Int>(bitPattern: UnsafePointer<Int>(pointer).memory)
        }
    }
}

func mutableStorageForInstance<T>(inout instance: T) -> UnsafeMutablePointer<Int> {
    return UnsafeMutablePointer<Int>(storageForInstance(&instance))
}

func storageForInstance<T>(inout instance: T) -> UnsafePointer<Int> {
    return withUnsafePointer(&instance) { pointer in
        if instance is AnyObject {
            return UnsafePointer<Int>(bitPattern: UnsafePointer<Int>(pointer).memory).advancedBy(2)
        } else {
            return UnsafePointer<Int>(pointer)
        }
    }
}
