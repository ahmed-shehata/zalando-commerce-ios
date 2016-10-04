//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import AtlasUI

class LocalizationSpec: QuickSpec {

    override func spec() {
        describe("Date extensions") {
            it("should format euro price after the number") {
                let deutschland = try! Localizer(localeIdentifier: "de_DE", localizedStringsBundle: NSBundle.mainBundle()) // swiftlint:disable:this force_try
                let price = deutschland.price(10)
                expect(price).to(equal("10,00 €"))
            }

            it("should format euro price before the number") {
                let france = try! Localizer(localeIdentifier: "en_FR", localizedStringsBundle: NSBundle.mainBundle()) // swiftlint:disable:this force_try
                let price = france.price(10)
                expect(price).to(equal("€10,00"))
            }

            it("should format pound price") {
                let brexit = try! Localizer(localeIdentifier: "en_UK", localizedStringsBundle: NSBundle.mainBundle()) // swiftlint:disable:this force_try
                let price = brexit.price(10)
                expect(price).to(equal("£10.00"))
            }
        }
    }

}
