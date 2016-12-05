//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasUI

class LocalizationTests: XCTestCase {

    func testGermanCurrency() {
        let deutschland = try! Localizer(localeIdentifier: "de_DE")
        let price = deutschland.format(price: 10)
        expect(price).to(equal("10,00 €"))
    }

    func testFrenchCurrency() {
        let france = try! Localizer(localeIdentifier: "en_FR")
        let price = france.format(price: 10)
        expect(price).to(equal("€10,00"))
    }

    func testUKCurrency() {
        let brexit = try! Localizer(localeIdentifier: "en_UK")
        let price = brexit.format(price: 10)
        expect(price).to(equal("£10.00"))
    }

}
