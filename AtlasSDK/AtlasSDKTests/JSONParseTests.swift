//
//   Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class JSONParseTests: JSONTestCase {

    func testParseString() {
        let json = try! JSON(string: "{\"int\": 500}")
        expect(json?["int"].int) == 500
    }

}

