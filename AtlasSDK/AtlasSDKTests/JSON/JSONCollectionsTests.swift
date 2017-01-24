//
//   Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class JSONCollectionsTests: JSONTestCase {

    let e0 = 42, e1 = 2.718, e2 = "string", e3 = true
    let e4 = URL(string: "http://foo.bar/baz/qux?quux=10#corge")!
    let e5 = Date(timeIntervalSince1970: 1467822790.537)

    func testArrayBasicElements() {
        expect(self.e0).to(equalJson(rawObjectAtPath: "collections", "array", 0))
        expect(self.e1).to(equalJson(rawObjectAtPath: "collections", "array", 1))
        expect(self.e2).to(equalJson(rawObjectAtPath: "collections", "array", 2))
        expect(self.e3).to(equalJson(rawObjectAtPath: "collections", "array", 3))
    }

    func testArrayHelperElements() {
        let jsonArr = self.json["collections", "array"]

        expect(jsonArr[4].url) == e4
        expect(jsonArr[5].date) == e5
    }

    func testDictionaryBasicElements() {
        expect(self.e0).to(equalJson(rawObjectAtPath: "collections", "dict", "e0"))
        expect(self.e1).to(equalJson(rawObjectAtPath: "collections", "dict", "e1"))
        expect(self.e2).to(equalJson(rawObjectAtPath: "collections", "dict", "e2"))
        expect(self.e3).to(equalJson(rawObjectAtPath: "collections", "dict", "e3"))
    }

    func testDictionaryHelperElements() {
        let jsonDict = self.json["collections", "dict"]

        expect(jsonDict["e4"].url) == e4
        expect(jsonDict["e5"].date) == e5
    }

}

