
import XCTest
import Reflection

class PerformanceTests: XCTestCase {
    
    let dictionary = ["firstName" : "Brad", "lastName": "Hilton", "age": 27] as [String : Any]
    let iterations = 0..<10_000
    var target = ""
    
    func testConstructType() {
        measure {
            for _ in self.iterations {
                guard let person: Person = try? construct(constructor: { self.dictionary[$0.key]! }) else { return }
                print(person, to: &self.target)
            }
        }
    }
    
    func testConstructTypeManually() {
        measure {
            for _ in self.iterations {
                let person = Person(firstName: self.dictionary["firstName"] as! String,
                                    lastName: self.dictionary["lastName"] as! String,
                                    age: self.dictionary["age"] as! Int)
                print(person, to: &self.target)
            }
        }
    }
    
}
