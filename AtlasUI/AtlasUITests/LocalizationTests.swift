//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasUI

class LocalizationTests: XCTestCase {

    func testGermanCurrency() {
        let deutschland = try! Localizer(localeIdentifier: "de_DE") // swiftlint:disable:this force_try
        let price = deutschland.price(10)
        expect(price).to(equal("10,00 €"))
    }

    func testFrenchCurrency() {
        let france = try! Localizer(localeIdentifier: "en_FR") // swiftlint:disable:this force_try
        let price = france.price(10)
        expect(price).to(equal("€10,00"))
    }

    func testUKCurrency() {
        let brexit = try! Localizer(localeIdentifier: "en_UK") // swiftlint:disable:this force_try
        let price = brexit.price(10)
        expect(price).to(equal("£10.00"))
    }

}
