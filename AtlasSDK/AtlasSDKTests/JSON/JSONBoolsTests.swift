//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class JSONBoolsTests: JSONTestCase {

    func testTrue() {
        expect(true).to(equalJson(rawObjectAtPath: "bools", "true"))
        expect(self.json["bools", "true"].bool).to(beTrue())
    }

    func testFalse() {
        expect(false).to(equalJson(rawObjectAtPath: "bools", "false"))
        expect(self.json["bools", "false"].bool).to(beFalse())
    }

    func testNotNumber() {
        expect(self.json["bools", "false"].number).to(beNil())
        expect(self.json["bools", "true"].number).to(beNil())
    }

}
