//
//   Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class JSONNumbersTests: JSONTestCase {

    func testInt0() {
        expect(0).to(equalJson(path: "numbers", "int0"))
    }

}

