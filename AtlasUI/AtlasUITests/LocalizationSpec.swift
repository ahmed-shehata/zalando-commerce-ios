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
                let deutschland = Localizer(localeIdentifier: "de_DE", localizedStringsBundle: NSBundle.mainBundle())
                let price = deutschland.price(10)
                expect(price).to(equal("10,00 €"))
            }

            it("should format euro price before the number") {
                let france = Localizer(localeIdentifier: "en_FR", localizedStringsBundle: NSBundle.mainBundle())
                let price = france.price(10)
                expect(price).to(equal("€10,00"))
            }

            it("should format pound price") {
                let brexit = Localizer(localeIdentifier: "en_UK", localizedStringsBundle: NSBundle.mainBundle())
                let price = brexit.price(10)
                expect(price).to(equal("£10.00"))
            }
        }
    }

}
