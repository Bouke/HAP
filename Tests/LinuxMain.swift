import XCTest
@testable import HAPTests

XCTMain([
     testCase(PairSetupControllerTests.allTests),
    testCase(EndpointTests.allTests),
    testCase(PairSetupControllerTests.allTests),
])
