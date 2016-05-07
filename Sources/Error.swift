
public enum Error : ErrorProtocol, CustomStringConvertible {
    
    case notStructOrClass(type: Any.Type)
    case classNotInitializable(type: Any.Type)
    case valueIsNotType(value: Any, type: Any.Type)
    case instanceHasNoKey(type: Any.Type, key: String)
    case requiredValueMissing(key: String)
    
    public var description: String {
        return "Reflection Error: \(caseDescription)"
    }
    
    var caseDescription: String {
        switch self {
        case .notStructOrClass(type: let type): return "\(type) is not a struct or class"
        case .classNotInitializable(type: let type): return "Class type \(type) cannot be constructed because it does not conform to Initializable"
        case .valueIsNotType(value: let value, type: let type): return "Cannot set value of type \(value.dynamicType) as \(type)"
        case .instanceHasNoKey(type: let type, key: let key): return "Instance of type \(type) has no key \(key)"
        case .requiredValueMissing(key: let key): return "No value found for required key \"\(key)\" in dictionary"
        }
    }
    
}
