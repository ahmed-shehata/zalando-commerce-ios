//
//   Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class JSONParseTests: JSONTestCase {

    func testParseCorrectString() {
        let json = try! JSON(string: "{\"int\": 500}")
        expect(json["int"].int) == 500
    }

    func testThrowErrorOnIncorrectString() {
        expect { try JSON(string: "{") }.to(throwError { (error: JSON.Error) in
            if case .parseError(_) = error { } else {
                fail("Not parseError")
            }
        })
    }

    func testParseNilOnIncorrectData() {
        expect { try JSON(string: "👹", encoding: .ascii) }.to(throwError(JSON.Error.incorrectData))
    }
}
