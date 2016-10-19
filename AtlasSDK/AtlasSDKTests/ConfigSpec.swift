//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Quick
import Nimble
import AtlasMockAPI

@testable import AtlasSDK

class ConfigSpec: QuickSpec {

    override func spec() {

        let catalogURL = AtlasMockAPI.endpointURL(forPath: "/catalog")
        let checkoutURL = AtlasMockAPI.endpointURL(forPath: "/checkout")
        let loginURL = AtlasMockAPI.endpointURL(forPath: "/login")

        let interfaceLanguage = "fr"
        let configLanguage = "de"
        let configCountry = "DE"
        let configLocale = "\(configLanguage)_\(configCountry)"
        let salesChannelId = "82fe2e7f-8c4f-4aa1-9019-b6bde5594456"
        let clientId = "CLIENT_ID"
        let tocURL = "https://www.zalando.de/agb/"
        let callback = "http://de.zalando.atlas.AtlasCheckoutDemo/redirect"

        let json = JSON([
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
            "oauth2-provider": ["url": loginURL.absoluteString]])

        describe("Config") {

            it("should correctly initialize from fully given data") {
                let options = Options(clientId: clientId, salesChannel: salesChannelId, interfaceLanguage: interfaceLanguage)
                let config = Config(json: json, options: options)

                expect(config?.catalogURL).to(equal(catalogURL))
                expect(config?.checkoutURL).to(equal(checkoutURL))
                expect(config?.loginURL).to(equal(loginURL))
                expect(config?.clientId).to(equal(clientId))
                expect(config?.salesChannel).to(equal(salesChannelId))
                expect(config?.tocURL).to(equal(NSURL(validURL: tocURL)))
            }

            it("should use config locale when no interface lanugage given") {
                let options = Options(clientId: clientId, salesChannel: salesChannelId)
                let config = Config(json: json, options: options)

                expect(config?.salesChannelLocale.localeIdentifier).to(equal(configLocale))
                expect(config?.interfaceLocale.localeIdentifier).to(equal(configLocale))
            }

            it("should use interface lanugage and config country") {
                let options = Options(clientId: clientId, salesChannel: salesChannelId, interfaceLanguage: interfaceLanguage)
                let config = Config(json: json, options: options)

                expect(config?.salesChannelLocale.localeIdentifier).to(equal(configLocale))
                expect(config?.interfaceLocale.localeIdentifier).to(equal("\(interfaceLanguage)_\(configCountry)"))
            }

            it("should not create config for invalid sales channel") {
                let options = Options(clientId: clientId, salesChannel: "INVALID")
                let config = Config(json: json, options: options)

                expect(config).to(beNil())
            }

        }
    }

}
