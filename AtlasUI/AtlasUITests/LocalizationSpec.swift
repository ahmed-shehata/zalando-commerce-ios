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
                let localizer = Localizer(localizationProvider: Germany())
                let price = localizer.fmtPrice(10)
                expect(price).to(equal("10,00 €"))
            }

            it("should format euro price before the number") {
                let localizer = Localizer(localizationProvider: FranceEnglish())
                let price = localizer.fmtPrice(10)
                expect(price).to(equal("€10,00"))
            }

            it("should format pound price") {
                let localizer = Localizer(localizationProvider: Brexit())
                let price = localizer.fmtPrice(10)
                expect(price).to(equal("£10.00"))
            }
        }
    }

    private struct Germany: Localizable {
        let localeIdentifier: String = "de_DE"
        let localizedStringsBundle: NSBundle = NSBundle.mainBundle()
    }

    private struct FranceEnglish: Localizable {
        let localeIdentifier: String = "en_FR"
        let localizedStringsBundle: NSBundle = NSBundle.mainBundle()
    }

    private struct Brexit: Localizable {
        let localeIdentifier: String = "en_UK"
        let localizedStringsBundle: NSBundle = NSBundle.mainBundle()
    }
}