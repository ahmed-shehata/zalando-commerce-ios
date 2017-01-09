//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasUI

class LocalizationTests: XCTestCase {

    func testGermanGermanyPriceFormat() {
        expectPrice(10, formattedFor: "de_DE", toBe: "10,00\u{00a0}€")
    }

    func testGermanGermanyFractionPriceFormat() {
        expectPrice(10.99, formattedFor: "de_DE", toBe: "10,99\u{00a0}€")
    }

    func testGermanGermanyFractionRoundedUpPriceFormat() {
        expectPrice(10.999, formattedFor: "de_DE", toBe: "11,00\u{00a0}€")
    }

    func testGermanGermanyFractionRoundedDownPriceFormat() {
        expectPrice(10.001, formattedFor: "de_DE", toBe: "10,00\u{00a0}€")
    }

    func testEnglishFrancePriceFormat() {
        expectPrice(10, formattedFor: "en_FR", toBe: "€10,00")
    }

    func testEnglishUKPriceFormat() {
        expectPrice(10, formattedFor: "en_UK", toBe: "£10.00")
    }

    func testGermanUKPriceFormat() {
        expectPrice(10, formattedFor: "de_UK", toBe: "10,00\u{00a0}£")
    }

    func testNegativeGermanGermanyPriceFormat() {
        expectPrice(-100, formattedFor: "de_DE", toBe: "-100,00\u{00a0}€")
    }

    func testNegativeFrenchUKPriceFormat() {
        expectPrice(-100, formattedFor: "fr_UK", toBe: "-100,00\u{00a0}£GB")
    }

    func testNegativeFrenchUKPriceWithOwnCurrencyFormat() {
        expectPrice(-100, inCurrency: "KABOOM", formattedFor: "fr_UK", toBe: "-100,00\u{00a0}KABOOM")
    }

    private func expectPrice(_ price: NSNumber, inCurrency currency: String? = nil, formattedFor identifier: String, toBe expectedFormat: String) {
        let loc = try! Localizer(localeIdentifier: identifier)
        let formattedPrice = loc.format(price: price, withCurrency: currency)

        expect(formattedPrice) == expectedFormat
    }

}
