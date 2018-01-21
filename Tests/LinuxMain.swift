@testable import HAPTests
import XCTest

XCTMain([
    testCase(EndpointTests.allTests),
    testCase(PairSetupControllerTests.allTests),
    testCase(PairVerifyControllerTests.allTests),
    testCase(TLV8Tests.allTests)
])
