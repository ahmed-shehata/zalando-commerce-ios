//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble
import AtlasMockAPI

@testable import AtlasSDK

class ConfigTests: XCTestCase {

    let catalogURL = AtlasMockAPI.endpointURL(forPath: "/catalog")
    let checkoutURL = AtlasMockAPI.endpointURL(forPath: "/checkout")
    let loginURL = AtlasMockAPI.endpointURL(forPath: "/login")

    let interfaceLanguage = "fr"
    let configLanguage = "de"
    let configCountry = "DE"
    let salesChannelId = "82fe2e7f-8c4f-4aa1-9019-b6bde5594456"
    let clientId = "partner_YCg9dRq"
    let tocURL = "https://www.zalando.de/agb/"
    let callback = "http://de.zalando.atlas.AtlasCheckoutDemo/redirect"

    var configLocale: String!
    var json: JSON!

    override func setUp() {
        super.setUp()

        configLocale = "\(configLanguage)_\(configCountry)"
        json = JSON(
            [
            "sales-channels": [
                ["locale": "es_ES", "sales-channel": "SPAIN", "toc_url": "https://www.zalando.es/cgc/"],
                ["locale": configLocale, "sales-channel": salesChannelId, "toc_url": tocURL],
            ],
            "atlas-catalog-api": ["url": catalogURL.absoluteString],
            "atlas-checkout-api": [
                "url": checkoutURL.absoluteString,
                "payment": [
                    "selection-callback": callback,
                    "third-party-callback": callback
                ]
            ],
            "oauth2-provider": ["url": loginURL.absoluteString]
            ]
        )
    }

    func testOptionInitialization() {
        let options = Options(clientId: clientId, salesChannel: salesChannelId, interfaceLanguage: interfaceLanguage)
        let config = Config(json: json, options: options)

        expect(config?.catalogURL).to(equal(catalogURL))
        expect(config?.checkoutURL).to(equal(checkoutURL))
        expect(config?.loginURL).to(equal(loginURL))
        expect(config?.clientId).to(equal(clientId))
        expect(config?.salesChannel.identifier).to(equal(salesChannelId))
        expect(config?.salesChannel.termsAndConditionsURL).to(equal(URL(validURL: tocURL)))
    }

    func testReadingLanguageFromConfigWhenNoInterfaceLanguageGiven() {
        let options = Options(clientId: clientId, salesChannel: salesChannelId)
        let config = Config(json: json, options: options)

        expect(config?.salesChannel.locale.identifier).to(equal(configLocale))
        expect(config?.interfaceLocale.identifier).to(equal(configLocale))
    }

    func testUseInterfaceLanugageWithConfigCountry() {
        let options = Options(clientId: clientId, salesChannel: salesChannelId, interfaceLanguage: interfaceLanguage)
        let config = Config(json: json, options: options)

        expect(config?.salesChannel.locale.identifier).to(equal(configLocale))
        expect(config?.interfaceLocale.identifier).to(equal("\(interfaceLanguage)_\(configCountry)"))
    }

    func testInvalidSalesChannel() {
        let options = Options(clientId: clientId, salesChannel: "INVALID")
        let config = Config(json: json, options: options)

        expect(config).to(beNil())
    }

}
