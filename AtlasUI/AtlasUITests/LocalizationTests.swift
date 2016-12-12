//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasUI

class LocalizationTests: XCTestCase {

    func testGermanGermanyPriceFormat() {
        expectPrice(10, formattedWith: "de_DE", toBe: "10,00\u{00a0}€")
    }

    func testGermanGermanyFractionPriceFormat() {
        expectPrice(10.9999, formattedWith: "de_DE", toBe: "10,99\u{00a0}€")
    }

    func testEnglishFrancePriceFormat() {
        expectPrice(10, formattedWith: "en_FR", toBe: "€10,00")
    }

    func testEnglishUKPriceFormat() {
        expectPrice(10, formattedWith: "en_UK", toBe: "£10.00")
    }

    func testGermanUKPriceFormat() {
        expectPrice(10, formattedWith: "de_UK", toBe: "10,00\u{00a0}£")
    }

    func testNegativeGermanGermanyPriceFormat() {
        expectPrice(-100, formattedWith: "de_DE", toBe: "-100,00\u{00a0}€")
    }

    func testNegativeFrenchUKPriceFormat() {
        expectPrice(-100, formattedWith: "fr_UK", toBe: "-100,00\u{00a0}£GB")
    }

    private func expectPrice(_ price: NSNumber, formattedWith identifier: String, toBe expectedFormat: String) {
        let formattedPrice = try! Localizer(localeIdentifier: identifier).format(price: price)

        expect(formattedPrice) == expectedFormat
    }

}
