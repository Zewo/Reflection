//
//  MetadataTests.swift
//  Reflection
//
//  Created by Bradley Hilton on 5/3/16.
//  Copyright © 2016 Zewo. All rights reserved.
//

import XCTest
@testable import Reflection

class InternalTests: XCTestCase {
    
    func testShallowMetadata() {
        func testShallowMetadata<T>(type: T.Type, expectedKind: Metadata.Kind) {
            let shallowMetadata = Metadata(type: type)
            XCTAssert(shallowMetadata.kind == expectedKind)
            XCTAssert(shallowMetadata.valueWitnessTable.size == sizeof(type))
            XCTAssert(shallowMetadata.valueWitnessTable.stride == strideof(type))
        }
        testShallowMetadata(type: Person.self, expectedKind: .Struct)
        testShallowMetadata(type: (String, Int).self, expectedKind: .Tuple)
        testShallowMetadata(type: ((String) -> Int).self, expectedKind: .Function)
        testShallowMetadata(type: Any.self, expectedKind: .Existential)
        testShallowMetadata(type: String.Type.self, expectedKind: .Metatype)
        testShallowMetadata(type: ReferencePerson.self, expectedKind: .Class)
    }
    
    func testMetadataKind() {

    }
    
    func testNominalMetadata() {
        func testMetadata<T : NominalType>(metadata: T, expectedName: String) {
            XCTAssert(metadata.nominalTypeDescriptor.numberOfFields == 3)
            XCTAssert(metadata.nominalTypeDescriptor.fieldNames == ["firstName", "lastName", "age"])
            XCTAssertNotNil(metadata.nominalTypeDescriptor.fieldTypesAccessor)
            XCTAssert(metadata.fieldTypes == [String.self, String.self, Int.self] as [Any.Type])
        }
        if let metadata = Metadata.Struct(type: Person.self) {
            testMetadata(metadata: metadata, expectedName: "Person")
        } else {
            XCTFail()
        }
        if let metadata = Metadata.Class(type: ReferencePerson.self) {
            testMetadata(metadata: metadata, expectedName: "ReferencePerson")
        } else {
            XCTFail()
        }
    }
    
    func testSuperclass() {
        guard let metadata = Metadata.Class(type: SubclassedPerson.self) else {
            return XCTFail()
        }
        XCTAssertNotNil(metadata.superclass) // ReferencePerson
    }
    
}

func ==(lhs: [Any.Type], rhs: [Any.Type]) -> Bool {
    return zip(lhs, rhs).reduce(true) { $1.0 != $1.1 ? false : $0 }
}

extension InternalTests {
    static var allTests: [(String, InternalTests -> () throws -> Void)] {
        return [
            ("testShallowMetadata", testShallowMetadata),
            ("testNominalMetadata", testNominalMetadata),
            ("testSuperclass", testSuperclass)
        ]
    }
}
