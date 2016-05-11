#if os(Linux)
    
import XCTest
@testable import ReflectionTestSuite
    
XCTMain([
    testCase(InternalTests.allTests),
    testCase(PublicTests.allTests),
    testCase(MappableTests.allTests)
])
    
#endif
