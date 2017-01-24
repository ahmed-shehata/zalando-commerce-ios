//
//   Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class JSONArraysTests: JSONTestCase {

    func testArrayBasicElements() {
        let e0 = 42, e1 = 2.718, e2 = "string", e3 = true

        expect(e0).to(equalJson(rawObjectAtPath: "collections", "array", 0))
        expect(e1).to(equalJson(rawObjectAtPath: "collections", "array", 1))
        expect(e2).to(equalJson(rawObjectAtPath: "collections", "array", 2))
        expect(e3).to(equalJson(rawObjectAtPath: "collections", "array", 3))
    }

    func testArrayHelperElements() {
        let e4 = URL(string: "http://foo.bar/baz/qux?quux=10#corge")!
        let e5 = Date(timeIntervalSince1970: 1467822790.537)
        
        let jsonArr = self.json["collections", "array"]

        expect(jsonArr[4].url) == e4
        expect(jsonArr[5].date) == e5
    }

}

