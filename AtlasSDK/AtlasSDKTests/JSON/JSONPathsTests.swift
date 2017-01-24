//
//   Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class JSONPathsTests: JSONTestCase {

    let indexedJson = try! JSON(string: "[[null, [null, null, \"value\", null]]]")!

    func testFindIncorrectInIndexPath() {
        expect(self.indexedJson.find(at: 100, 200, 300)).to(beNil())
    }

    func testSubscriptCorrectStringPath() {
        let value = json["paths", "stringPath", "l1", "l2", "l3"]
        expect(value.string) == "value"
    }

    func testSubscriptCorrectMixedPath() {
        let value = json["paths", "mixedPath", 0, 1, 2]
        expect(value.string) == "value"
    }

    func testSubscriptCorrectIndexPath() {
        let arr = indexedJson[0, 1]
        expect(arr[1].isNull) == true
        expect(arr[2].string) == "value"
        expect(arr[3].isNull) == true
    }

    func testSubscriptIncorrectStringPath() {
        expect(self.json["paths", "stringPath", "x1", "l2", "x3"]) == JSON.null
    }

    func testSubscriptIncorrectNullResultIndexPath() {
        expect(self.indexedJson[100, 200, 300]) == JSON.null
    }

    func testSubscriptIncorrectMixedPath() {
        expect(self.json["paths", "stringPath", 100, 200, 300]) == JSON.null
    }


}

