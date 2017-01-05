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

        expect(config.catalogURL) == TestConsts.catalogURL
        expect(config.checkoutURL) == TestConsts.checkoutURL
        expect(config.loginURL) == TestConsts.loginURL
        expect(config.clientId) == TestConsts.clientId
        expect(config.salesChannel.identifier) == TestConsts.salesChannel
        expect(config.salesChannel.termsAndConditionsURL) == URL(validURL: TestConsts.tocURL)
    }

    func testReadingLanguageFromConfigWhenNoInterfaceLanguageGiven() {
        let options = Options(clientId: TestConsts.clientId, salesChannel: TestConsts.salesChannel)
        let config = Config.forTests(options: options)

        expect(config.salesChannel.locale.identifier) == TestConsts.configLocale
        expect(config.interfaceLocale.identifier) == TestConsts.configLocale
    }

    func testUseInterfaceLanugageWithConfigCountry() {
        let config = Config.forTests()

        expect(config.salesChannel.locale.identifier) == TestConsts.configLocale
        expect(config.interfaceLocale.identifier) == "\(TestConsts.interfaceLanguage)_\(TestConsts.configCountry)"
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
