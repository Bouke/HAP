@testable import HAPTests
import XCTest

XCTMain([
    testCase(AccessoriesTests.allTests),
    testCase(CharacteristicTests.allTests),
    testCase(DeviceTests.allTests),
    testCase(EndpointTests.allTests),
    testCase(PairingsEndpointTests.allTests),
    testCase(PairSetupControllerTests.allTests),
    testCase(PairVerifyControllerTests.allTests),
    testCase(TLV8Tests.allTests),
    testCase(StorageTests.allTests),
    testCase(CryptographerTests.allTests)
])
