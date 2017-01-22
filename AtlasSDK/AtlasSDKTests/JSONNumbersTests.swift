//
//   Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class JSONNumbersTests: JSONTestCase {

    func testInt0() {
        expect(0).to(equalJson(path: "numbers", "int0"))
    }

    func testInt1() {
        expect(1).to(equalJson(path: "numbers", "int1"))
    }

    func testInt0NotBool() {
        expect(self.json["numbers", "int0"].bool).to(beNil())
    }

    func testInt1NotBool() {
        expect(self.json["numbers", "int1"].bool).to(beNil())
    }

    func testBigInt() {
        expect(5000000000).to(equalJson(path: "numbers", "bigInt"))
    }

    func testBigNegativeInt() {
        expect(-5000000000).to(equalJson(path: "numbers", "bigNegativeInt"))
    }

    func testFloat0() {
        expect(0.0).to(equalJson(path: "numbers", "float0"))
    }

    func testFloat1() {
        expect(1.1).to(equalJson(path: "numbers", "float1"))
    }

    func testBigFloat() {
        expect(5000000000.500123).to(equalJson(path: "numbers", "bigFloat"))
    }

    func testBitNegativeFloat() {
        expect(-5000000000.500123).to(equalJson(path: "numbers", "bigNegativeFloat"))
    }

}

