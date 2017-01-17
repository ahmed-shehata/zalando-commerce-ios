//
//   Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class JSONTests: XCTestCase {

    func testInt0() {
        let json = try! JSON(string: "{\"int\": 0}")
        expect(json?["int"].int) == 0
    }

    func testInt1() {
        let json = try! JSON(string: "{\"int\": 1}")
        expect(json?["int"].int) == 1
    }

    func testInt10() {
        let json = try! JSON(string: "{\"int\": 10}")
        expect(json?["int"].int) == 10
    }

    func testIntBigInt() {
        let json = try! JSON(string: "{\"int\": 100000000000123}")
        expect(json?["int"].int) == 100000000000123
    }

    func testIntBigFloat() {
        let json = try! JSON(string: "{\"float\": 100000000000.123}")
        expect(json?["float"].float) == 100000000000.123
    }

}

