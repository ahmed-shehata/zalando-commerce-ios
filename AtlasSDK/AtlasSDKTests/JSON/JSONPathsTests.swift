//
//   Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class JSONPathsTests: JSONTestCase {

    func testCorrectStringPath() {
        let value = json["paths", "stringPath", "l1", "l2", "l3"]
        expect(value.string) == "value"
    }

    func testCorrectMixedPath() {
        let value = json["paths", "mixedPath", 0, 1, 2]
        expect(value.string) == "value"
    }

    func testCorrectIndexPath() {
        let json = try! JSON(string: "[[null, [null, null, \"value\", null]]]")!
        let arr = json[0, 1]
        expect(arr[1].isNull) == true
        expect(arr[2].string) == "value"
        expect(arr[3].isNull) == true
    }

    func testIncorrectStringPath() {
        let value = json["paths", "stringPath", "x1", "l2", "x3"]
        expect(value.string).to(beNil())
    }

    func testIncorrectIndexPath() {
        let json = try! JSON(string: "[[null, [null, null, \"value\", null]]]")!
        expect(json[100, 200, 300]).to(beNil())
    }

    func testIncorrectMixedPath() {
        let value = json["paths", "stringPath", 100, 200, 300]
        expect(value.string).to(beNil())
    }


}

