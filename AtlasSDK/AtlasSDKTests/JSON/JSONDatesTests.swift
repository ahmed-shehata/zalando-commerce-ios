//
//   Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class JSONDatesTests: JSONTestCase {

    func testRFC3339DateWithSecondsPrecision() {
        let date = Date(timeIntervalSince1970: 1467822790)
        expect(date) == json["dates", "secondsPrecision"].date
    }

    func testRFC3339DateWithMillisecondsPrecision() {
        let date = Date(timeIntervalSince1970: 1467822790.537)
        expect(date) == json["dates", "millisecondsPrecision"].date
    }

    func testWrongDate() {
        expect(self.json["dates", "wrongDate"].date).to(beNil())
    }

    func testWrongFormat() {
        expect(self.json["dates", "wrongFormat"].date).to(beNil())
    }

    func testNotDate() {
        expect(self.json["dates", "notDate"].date).to(beNil())
    }

}
