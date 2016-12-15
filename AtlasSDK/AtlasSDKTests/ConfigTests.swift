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

        expect(config.catalogURL).to(equal(TestConfig.catalogURL))
        expect(config.checkoutURL).to(equal(TestConfig.checkoutURL))
        expect(config.loginURL).to(equal(TestConfig.loginURL))
        expect(config.clientId).to(equal(TestOptions.clientId))
        expect(config.salesChannel.identifier).to(equal(TestOptions.salesChannel))
        expect(config.salesChannel.termsAndConditionsURL).to(equal(URL(validURL: TestConfig.tocURL)))
    }

    func testReadingLanguageFromConfigWhenNoInterfaceLanguageGiven() {
        let options = Options(clientId: TestOptions.clientId, salesChannel: TestOptions.salesChannel)
        let config = Config.forTests(options: options)

        expect(config.salesChannel.locale.identifier).to(equal(TestConfig.configLocale))
        expect(config.interfaceLocale.identifier).to(equal(TestConfig.configLocale))
    }

    func testUseInterfaceLanugageWithConfigCountry() {
        let config = Config.forTests()

        expect(config.salesChannel.locale.identifier).to(equal(TestConfig.configLocale))
        expect(config.interfaceLocale.identifier).to(equal("\(TestOptions.interfaceLanguage)_\(TestConfig.configCountry)"))
    }

    func testInvalidSalesChannel() {
        let json = Config.jsonForTests()
        let options = Options(clientId: TestOptions.clientId, salesChannel: "INVALID")
        let config = Config(json: json, options: options)

        expect(config).to(beNil())
    }

    func testGuestCheckoutEnabled() {
        let options = Options.forTests()
        var json = Config.jsonForTests(options: options)
        
        json["atlas-guest-checkout-api"] = JSON(["enabled" : JSON(true)])
        let config = Config(json: json, options: options)
        expect(config?.guestCheckoutEnabled) == true

        json["atlas-guest-checkout-api"] = JSON.null
        let config2 = Config(json: json, options: options)
        expect(config2?.guestCheckoutEnabled) == false
    }

}
