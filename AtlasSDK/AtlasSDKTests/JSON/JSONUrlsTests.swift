//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class JSONUrlsTests: JSONTestCase {

    func testHttpUrl() {
        let url = URL(string: "http://foo.bar/baz/qux?quux=10#corge")
        expect(url) == json["urls", "httpUrl"].url
    }

    func testHttpsUrl() {
        let url = URL(string: "https://foo.bar/baz/qux?quux=10#corge")
        expect(url) == json["urls", "httpsUrl"].url
    }

    func testFileUrl() {
        let url = URL(string: "file:///foo/bar/baz.swift")
        expect(url) == json["urls", "fileUrl"].url
    }

    func testWrongUrl() {
        expect(self.json["urls", "wrongUrl"].url).to(beNil())
    }

}
