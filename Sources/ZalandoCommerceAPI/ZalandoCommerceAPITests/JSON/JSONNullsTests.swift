//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import ZalandoCommerceAPI

class JSONNullsTests: JSONTestCase {

    func testJSONFromNil() {
        expect(JSON(NSNull())) == JSON.null
        expect(JSON(nil)) == JSON.null
    }

    func testNullString() {
        let nullString = self.json["nulls", "nullString"]
        expect(nullString.string) == "null"
        expect(nullString.bool).to(beNil())
        expect(nullString.isNull) == false
        expect(nullString == JSON.null) == false
    }

    func testNullValue() {
        let nullJson = json["nulls", "nullValue"]
        expect(nullJson.string).to(beNil())
        expect(nullJson.bool).to(beNil())
        expect(nullJson.isNull) == true
        expect(nullJson == JSON.null) == true
    }

}
