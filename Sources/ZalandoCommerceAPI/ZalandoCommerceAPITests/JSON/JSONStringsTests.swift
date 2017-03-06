//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import ZalandoCommerceAPI

class JSONStringsTests: JSONTestCase {

    func testOrdinaryString() {
        expect("ordinaryString").to(equalJson(rawObjectAtPath: "strings", "ordinaryString"))
        expect(self.json["strings", "ordinaryString"].string) == "ordinaryString"
    }

    func testTrueString() {
        expect(self.json["strings", "trueString"].string) == "true"
        expect(self.json["strings", "trueString"].bool).to(beNil())
    }

    func testTrueValue() {
        expect(self.json["strings", "trueValue"].string).to(beNil())
        expect(self.json["strings", "trueValue"].bool).to(beTrue())
    }


}

