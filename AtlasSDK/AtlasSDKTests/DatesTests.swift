//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class DatesTests: XCTestCase {

    func testFormatDate() {
        let expectedFormattedDate = "2016-07-06T16:33:10.000+0000"

        let date = NSDate(timeIntervalSince1970: 1467822790)
        let formattedDate = RFC3339DateFormatter().stringFromDate(date)
        expect(expectedFormattedDate).to(equal(formattedDate))
    }

    func testBuildDate() {
        let expectedDate = NSDate(timeIntervalSince1970: 1467822790)

        let textDate = "2016-07-06T16:33:10.000+0000"
        let parsedDate = RFC3339DateFormatter().dateFromString(textDate)
        expect(expectedDate).to(equal(parsedDate))
    }

    func testBuildDateWithTimeShift() {
        let expectedDate = NSDate(timeIntervalSince1970: 1467822790)

        let textDate = "2016-07-06T18:33:10.000+02:00"
        let parsedDate = RFC3339DateFormatter().dateFromString(textDate)
        expect(expectedDate).to(equal(parsedDate))
    }

    func testNilDate() {
        let parsedDate = RFC3339DateFormatter().dateFromString(nil)
        expect(parsedDate).to(beNil())
    }

}
