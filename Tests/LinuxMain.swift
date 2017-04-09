import XCTest
@testable import HAPTests

XCTMain([
    testCase(EndpointTests.allTests),
    testCase(PairSetupControllerTests.allTests),
    testCase(TLV8Tests.allTests),
])
