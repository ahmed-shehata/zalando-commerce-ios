//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble
import AtlasMockAPI

@testable import AtlasSDK

class ConfigTests: XCTestCase {

    func testOptionInitialization() {
        let config = Config.forTests()

        expect(config.catalogURL).to(equal(TestConsts.catalogURL))
        expect(config.checkoutURL).to(equal(TestConsts.checkoutURL))
        expect(config.loginURL).to(equal(TestConsts.loginURL))
        expect(config.clientId).to(equal(TestConsts.clientId))
        expect(config.salesChannel.identifier).to(equal(TestConsts.salesChannel))
        expect(config.salesChannel.termsAndConditionsURL).to(equal(URL(validURL: TestConsts.tocURL)))
    }

    func testReadingLanguageFromConfigWhenNoInterfaceLanguageGiven() {
        let options = Options(clientId: TestConsts.clientId, salesChannel: TestConsts.salesChannel)
        let config = Config.forTests(options: options)

        expect(config.salesChannel.locale.identifier).to(equal(TestConsts.configLocale))
        expect(config.interfaceLocale.identifier).to(equal(TestConsts.configLocale))
    }

    func testUseInterfaceLanugageWithConfigCountry() {
        let config = Config.forTests()

        expect(config.salesChannel.locale.identifier).to(equal(TestConsts.configLocale))
        expect(config.interfaceLocale.identifier).to(equal("\(TestConsts.interfaceLanguage)_\(TestConsts.configCountry)"))
    }

    func testInvalidSalesChannel() {
        let json = Config.jsonForTests()
        let options = Options(clientId: TestConsts.clientId, salesChannel: "INVALID")
        let config = Config(json: json, options: options)

        expect(config).to(beNil())
    }

    func testGuestCheckoutEnabled() {
        let options = Options.forTests()
        var json = Config.jsonForTests(options: options)

        json["atlas-guest-checkout-api"] = JSON(["enabled": JSON(true)])
        let config = Config(json: json, options: options)
        expect(config?.guestCheckoutEnabled) == true

        json["atlas-guest-checkout-api"] = JSON.null
        let config2 = Config(json: json, options: options)
        expect(config2?.guestCheckoutEnabled) == false
    }

}
