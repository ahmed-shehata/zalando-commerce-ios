//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Quick
import Nimble
@testable import AtlasSDK

class DatesSpec: QuickSpec {

    override func spec() { // swiftlint:disable:this function_body_length
        describe("Date extensions") {

            it("ISO8601DateFormatter should correctly format date") {
                let expectedFormattedDate = "2016-07-06T16:33:10.000"

                let date = NSDate(timeIntervalSince1970: 1467822790)
                
                let formattedDate = RFC3339DateFormatter().stringFromDate(date)

                expect(expectedFormattedDate).to(equal(formattedDate))
            }

            it("ISO8601DateFormatter should correctly build date") {
                let expectedDate = NSDate(timeIntervalSince1970: 1467822790)

                let textDate = "2016-07-06T16:33:10.000"
                let parsedDate = RFC3339DateFormatter().dateFromString(textDate)

                expect(expectedDate).to(equal(parsedDate))
            }

            it("Date formatter built from convenience init should correctly parse date") {
                let expectedDate = NSDate(timeIntervalSince1970: 1467822790)

                let df = NSDateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZZZZ",
                    localeIdentifier: "de_DE", timeZone: "CEST")
                let textDate = "2016-07-06T18:33:10.000+02:00"
                let parsedDate = df.dateFromString(textDate)

                expect(expectedDate).to(equal(parsedDate))
            }

            it("Correct date string should be converted to date") {
                let expectedFormattedDate = "2016-07-06T16:33:10.000"

                let date = NSDate(timeIntervalSince1970: 1467822790)
                let formattedDate = String(fromDate: date, formatter: ISO8601DateFormatter)

                expect(expectedFormattedDate).to(equal(formattedDate))
            }

            it("A string should return nil from nil date") {
                let formattedDate = String(fromDate: nil, formatter: ISO8601DateFormatter)

                expect(formattedDate).to(beNil())
            }

            it("Correct date should be parsed from string") {
                let expectedDate = NSDate(timeIntervalSince1970: 1467822790)

                let formattedDate = "2016-07-06T16:33:10.000"

                let parsedDate = NSDate(object: formattedDate, formatter: ISO8601DateFormatter)

                expect(expectedDate).to(equal(parsedDate))
            }

            it("A date should return nil from nil object") {
                let parsedDate = NSDate(object: nil, formatter: ISO8601DateFormatter)

                expect(parsedDate).to(beNil())
            }

            it("A date should return nil from anything but string") {
                let parsedDate1 = NSDate(object: 1467822790, formatter: ISO8601DateFormatter)
                let parsedDate2 = NSDate(object: true, formatter: ISO8601DateFormatter)
                let parsedDate3 = NSDate(object: [], formatter: ISO8601DateFormatter)

                expect(parsedDate1).to(beNil())
                expect(parsedDate2).to(beNil())
                expect(parsedDate3).to(beNil())
            }

        }
    }

}
