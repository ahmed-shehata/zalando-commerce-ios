//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class DatesTests: XCTestCase {

    func testFormatDate() {
        let expectedFormattedDate = "2016-07-06T16:33:10.000+0000"

        let date = Date(timeIntervalSince1970: 1467822790)
        let formattedDate = RFC3339DateFormatter().string(from: date)
        expect(expectedFormattedDate) == formattedDate
    }

    func testBuildDate() {
        let expectedDate = Date(timeIntervalSince1970: 1467822790)

        let textDate = "2016-07-06T16:33:10.000+0000"
        let parsedDate = RFC3339DateFormatter().date(from: textDate)
        expect(expectedDate) == parsedDate
    }

    func testBuildDateWithTimeShift() {
        let expectedDate = Date(timeIntervalSince1970: 1467822790)

        let textDate = "2016-07-06T18:33:10.000+02:00"
        let parsedDate = RFC3339DateFormatter().date(from: textDate)
        expect(expectedDate) == parsedDate
    }

    func testNilDate() {
        let parsedDate = RFC3339DateFormatter().date(from: nil)
        expect(parsedDate).to(beNil())
    }

}
