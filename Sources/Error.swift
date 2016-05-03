//
//  Error.swift
//  Allegro
//
//  Created by Bradley Hilton on 3/16/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

public enum Error : ErrorType, CustomStringConvertible {
    
    case NotStructOrClass(type: Any.Type)
    case ClassNotInitializable(type: Any.Type)
    case ValueIsNotOfType(value: Any, type: Any.Type)
    case InstanceHasNoKey(type: Any.Type, key: String)
    case RequiredValueMissing(key: String)
    
    public var description: String {
        return "Allegro Error: \(caseDescription)"
    }
    
    var caseDescription: String {
        switch self {
        case .NotStructOrClass(type: let type): return "\(type) is not a struct or class"
        case .ClassNotInitializable(type: let type): return "Class type \(type) cannot be constructed because it does not conform to Initializable"
        case .ValueIsNotOfType(value: let value, type: let type): return "Cannot set value of type \(value.dynamicType) as \(type)"
        case .InstanceHasNoKey(type: let type, key: let key): return "Instance of type \(type) has no key \(key)"
        case .RequiredValueMissing(key: let key): return "No value found for required key \"\(key)\" in dictionary"
        }
    }
    
}
