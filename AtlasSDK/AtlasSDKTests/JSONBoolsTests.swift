//
//   Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class JSONBoolsTests: JSONTestCase {

    func testTrue() {
        expect(true).to(equalJson(path: "bools", "true"))
    }

    func testFalse() {
        expect(false).to(equalJson(path: "bools", "false"))
    }

    func testNotNumber() {
        expect(self.json["bools", "false"].number).to(beNil())
        expect(self.json["bools", "true"].number).to(beNil())
    }

}

