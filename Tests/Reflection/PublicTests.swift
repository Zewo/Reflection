//
//  ReflectionTests.swift
//  ReflectionTests
//
//  Created by Bradley Hilton on 5/3/16.
//  Copyright © 2016 Zewo. All rights reserved.
//

import XCTest
import Reflection

struct Person : Equatable {
    
    var firstName: String
    var lastName: String
    var age: Int
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
}

func ==(lhs: Person, rhs: Person) -> Bool {
    return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.age == rhs.age
}

class ReferencePerson : Initializable, Equatable {
    
    var firstName: String
    var lastName: String
    var age: Int
    
    required init() {
        self.firstName = ""
        self.lastName = ""
        self.age = 0
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
}

func ==(lhs: ReferencePerson, rhs: ReferencePerson) -> Bool {
    return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.age == rhs.age
}

class PublicTests: XCTestCase {
    
    func testConstructType() {
        for _ in 0..<1000 {
            do {
                let person: Person = try construct {
                    (["firstName" : "Brad", "lastName": "Hilton", "age": 27] as [String : Any])[$0.key]!
                }
                let other = Person(firstName: "Brad", lastName: "Hilton", age: 27)
                XCTAssert(person == other)
            } catch {
                XCTFail(String(error))
            }
        }
    }
    
    func testConstructReferenceType() {
        for _ in 0..<1000 {
            do {
                let person: ReferencePerson = try construct {
                    (["firstName" : "Brad", "lastName": "Hilton", "age": 27] as [String : Any])[$0.key]!
                }
                let other = ReferencePerson(firstName: "Brad", lastName: "Hilton", age: 27)
                XCTAssert(person == other)
            } catch {
                XCTFail(String(error))
            }
        }
    }
    
    func testPropertiesForInstance() {
        var properties = [Property]()
        do {
            let person = Person(firstName: "Brad", lastName: "Hilton", age: 27)
            properties = try Reflection.properties(person)
            guard properties.count == 3 else {
                XCTFail("Unexpected number of properties"); return
            }
            guard let firstName = properties[0].value as? String, let lastName = properties[1].value as? String, let age = properties[2].value as? Int else {
                XCTFail("Unexpected properties"); return
            }
            XCTAssert(person.firstName == firstName)
            XCTAssert(person.lastName == lastName)
            XCTAssert(person.age == age)
        } catch {
            XCTFail(String(error))
        }
        print(properties)
    }
    
    func testSetValueForKeyOfInstance() {
        do {
            var person = Person(firstName: "Brad", lastName: "Hilton", age: 27)
            try Reflection.set("Lawrence", key: "firstName", for: &person)
            XCTAssert(person.firstName == "Lawrence")
        } catch {
            XCTFail(String(error))
        }
        
    }
    
    func testValueForKeyOfInstance() {
        do {
            let person = Person(firstName: "Brad", lastName: "Hilton", age: 29)
            let firstName: String = try Reflection.get("firstName", from: person)
            XCTAssert(person.firstName == firstName)
        } catch {
            XCTFail(String(error))
        }
    }
    
    func testValueIs() {
        XCTAssert(Reflection.value("John", is: String.self))
        XCTAssert(Reflection.value(89, is: Int.self))
        XCTAssert(Reflection.value(["Larry"], is: Array<String>.self))
        XCTAssert(!Reflection.value("John", is: Array<String>.self))
        XCTAssert(!Reflection.value(89, is: String.self))
        XCTAssert(!Reflection.value(["Larry"], is: Int.self))
        class SubclassedPerson : ReferencePerson {}
        let person = Person(firstName: "Hillary", lastName: "Mason", age: 32)
        let referencePerson = ReferencePerson()
        let subclassedPerson = SubclassedPerson()
        XCTAssert(Reflection.value(person, is: Person.self))
        XCTAssert(Reflection.value(referencePerson, is: ReferencePerson.self))
        XCTAssert(!Reflection.value(person, is: ReferencePerson.self))
        XCTAssert(!Reflection.value(referencePerson, is: Person.self))
        XCTAssert(Reflection.value(subclassedPerson, is: SubclassedPerson.self))
        XCTAssert(Reflection.value(subclassedPerson, is: ReferencePerson.self))
        XCTAssert(!Reflection.value(referencePerson, is: SubclassedPerson.self))
    }
    
}

extension PublicTests {
    static var allTests: [(String, PublicTests -> () throws -> Void)] {
        return [
            ("testConstructType", testConstructType),
            ("testConstructReferenceType", testConstructReferenceType),
            ("testPropertiesForInstance", testPropertiesForInstance),
            ("testSetValueForKeyOfInstance", testSetValueForKeyOfInstance),
            ("testValueForKeyOfInstance", testValueForKeyOfInstance),
            ("testValueIs", testValueIs)
        ]
    }
}
