//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Nimble

@testable import AtlasSDK

class DatesSpec: QuickSpec {

    override func spec() { // swiftlint:disable:this function_body_length
        describe("Date extensions") {

            it("ISO8601DateFormatter should correctly format date") {
                let expectedFormattedDate = "2016-07-06T16:33:10.000+0000"

                let date = NSDate(timeIntervalSince1970: 1467822790)

                let formattedDate = RFC3339DateFormatter().stringFromDate(date)
                expect(expectedFormattedDate).to(equal(formattedDate))
            }

            it("ISO8601DateFormatter should correctly build date") {
                let expectedDate = NSDate(timeIntervalSince1970: 1467822790)

                let textDate = "2016-07-06T16:33:10.000+0000"
                let parsedDate = RFC3339DateFormatter().dateFromString(textDate)
                expect(expectedDate).to(equal(parsedDate))
            }

            it("Date formatter built from convenience init should correctly parse date") {
                let expectedDate = NSDate(timeIntervalSince1970: 1467822790)

                let textDate = "2016-07-06T18:33:10.000+02:00"
                let parsedDate = RFC3339DateFormatter().dateFromString(textDate)

                expect(expectedDate).to(equal(parsedDate))
            }

            it("Correct date string should be converted to date") {
                let expectedFormattedDate = "2016-07-06T16:33:10.000+0000"

                let date = NSDate(timeIntervalSince1970: 1467822790)
                let formattedDate = RFC3339DateFormatter().stringFromDate(date)

                expect(expectedFormattedDate).to(equal(formattedDate))
            }

            it("Correct date should be parsed from string") {
                let expectedDate = NSDate(timeIntervalSince1970: 1467822790)

                let formattedDate = "2016-07-06T16:33:10.000+0000"

                let parsedDate = RFC3339DateFormatter().dateFromString(formattedDate)
                expect(expectedDate).to(equal(parsedDate))
            }

            it("A date should return nil from nil object") {
                let parsedDate = RFC3339DateFormatter().dateFromString(nil)

                expect(parsedDate).to(beNil())
            }

        }
    }

}
