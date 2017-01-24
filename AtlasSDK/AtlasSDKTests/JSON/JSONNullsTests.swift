//
//   Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class JSONNullsTests: JSONTestCase {

    func testNullString() {
        expect(self.json["strings", "nullString"].string) == "null"
        expect(self.json["strings", "nullString"].bool).to(beNil())
    }

    func testNullValue() {
        expect(self.json["strings", "nullValue"].string).to(beNil())
        expect(self.json["strings", "nullValue"].bool).to(beTrue())
    }


}

