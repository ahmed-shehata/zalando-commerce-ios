//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import ZalandoCommerceAPI

class JSONCollectionsTests: JSONTestCase {

    let e0 = 42, e1 = 2.718, e2 = "string", e3 = true
    let e4 = URL(string: "http://foo.bar/baz/qux?quux=10#corge")!
    let e5 = Date(timeIntervalSince1970: 1467822790.537)

    func testArrayBasicElements() {
        expect(self.e0).to(equalJson(rawObjectAtPath: "collections", "array", 0))
        expect(self.e1).to(equalJson(rawObjectAtPath: "collections", "array", 1))
        expect(self.e2).to(equalJson(rawObjectAtPath: "collections", "array", 2))
        expect(self.e3).to(equalJson(rawObjectAtPath: "collections", "array", 3))
        expect(self.json["collections", "array", 6].isNull) == true
    }

    func testArrayHelper() {
        expect(self.json["collections", "array"].array).toNot(beEmpty())
        expect(self.json["collections", "dict"].array).to(beNil())
    }

    func testJsonsHelper() {
        let jsons = self.json["collections", "array"].jsons

        expect(jsons[4].url) == e4
        expect(jsons[5].date) == e5
    }

    func testDictionaryBasicElements() {
        expect(self.e0).to(equalJson(rawObjectAtPath: "collections", "dict", "e0"))
        expect(self.e1).to(equalJson(rawObjectAtPath: "collections", "dict", "e1"))
        expect(self.e2).to(equalJson(rawObjectAtPath: "collections", "dict", "e2"))
        expect(self.e3).to(equalJson(rawObjectAtPath: "collections", "dict", "e3"))
        expect(self.json["collections", "array", "e6"].isNull) == true
    }

    func testDictionaryHelper() {
        expect(self.json["collections", "dict"].dictionary).toNot(beEmpty())
        expect(self.json["collections", "array"].dictionary).to(beNil())
    }

    func testDictionaryHelperElements() {
        let jsonDict = self.json["collections", "dict"].dictionary!

        expect(jsonDict["e0"] as? Int) == e0
        expect(jsonDict["e1"] as? Double) == e1
        expect(jsonDict["e2"] as? String) == e2
        expect(jsonDict["e3"] as? Bool) == e3
    }

}
