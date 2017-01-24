//
//   Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class JSONNumbersTests: JSONTestCase {

    func testInt0() {
        expect(0).to(equalJson(rawObjectAtPath: "numbers", "int0"))
        expect(self.json["numbers", "int0"].int) == 0
    }

    func testInt1() {
        expect(1).to(equalJson(rawObjectAtPath: "numbers", "int1"))
        expect(self.json["numbers", "int1"].int) == 1
    }

    func testInt0NotBool() {
        expect(self.json["numbers", "int0"].bool).to(beNil())
    }

    func testInt1NotBool() {
        expect(self.json["numbers", "int1"].bool).to(beNil())
    }

    func testBigInt() {
        expect(5000000000).to(equalJson(rawObjectAtPath: "numbers", "bigInt"))
    }

    func testBigNegativeInt() {
        expect(-5000000000).to(equalJson(rawObjectAtPath: "numbers", "bigNegativeInt"))
    }

    func testFloat0() {
        expect(0).to(equalJson(rawObjectAtPath: "numbers", "float0"))
        expect(self.json["numbers", "float0"].float) == 0
    }

    func testFloat1() {
        expect(1.1).to(equalJson(rawObjectAtPath: "numbers", "float1"))
        expect(self.json["numbers", "float1"].float) == 1.1
    }

    func testDouble() {
        expect(1.100000000000001).to(equalJson(rawObjectAtPath: "numbers", "double"))
        expect(self.json["numbers", "double"].double) == 1.100000000000001
    }

    func testBigFloat() {
        expect(5000000000.500123).to(equalJson(rawObjectAtPath: "numbers", "bigFloat"))
        expect(self.json["numbers", "bigFloat"].float) == 5000000000.500123

    }

    func testBitNegativeFloat() {
        expect(-5000000000.500123).to(equalJson(rawObjectAtPath: "numbers", "bigNegativeFloat"))
        expect(self.json["numbers", "bigNegativeFloat"].float) == -5000000000.500123
    }

}

