//
//  getFieldAt.swift
//  Reflection
//
//  Created by Bradley Hilton on 10/1/18.
//

import Foundation

@_silgen_name("swift_getFieldAt")
func _getFieldAt(
    _ type: Any.Type,
    _ index: Int,
    _ callback: @convention(c) (
        _ mangledName: UnsafePointer<CChar>,
        _ type: UnsafeRawPointer,
        _ context: UnsafeMutableRawPointer
    ) -> Void,
    _ context: UnsafeMutableRawPointer
)
