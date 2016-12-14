//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasMockAPI

@testable import AtlasSDK

struct TestConfig {

    static let catalogURL = AtlasMockAPI.endpointURL(forPath: "/catalog")
    static let checkoutURL = AtlasMockAPI.endpointURL(forPath: "/checkout")
    static let loginURL = AtlasMockAPI.endpointURL(forPath: "/login")

    static let configLanguage = "de"
    static let configCountry = "DE"
    static let tocURL = "https://www.zalando.de/agb/"
    static let callback = "http://de.zalando.atlas.AtlasCheckoutDemo/redirect"

    static let gateway = "http://localhost.charlesproxy.com:9080"
    static var configLocale: String { return "\(configLanguage)_\(configCountry)" }

}

extension Config {

    static func forTests() -> Config {
        let opts = Options.forTests()
        let json = JSON([
                            "sales-channels": [
                                ["locale": "es_ES", "sales-channel": "SPAIN", "toc_url": "https://www.zalando.es/cgc/"],
                                ["locale": TestConfig.configLocale,
                                 "sales-channel": opts.salesChannel,
                                 "toc_url": TestConfig.tocURL],
                            ],
                            "atlas-catalog-api": ["url": TestConfig.catalogURL.absoluteString],
                            "atlas-checkout-gateway": ["url": TestConfig.gateway],
                            "atlas-checkout-api": [
                                "url": TestConfig.checkoutURL.absoluteString,
                                "payment": [
                                    "selection-callback": TestConfig.callback,
                                    "third-party-callback": TestConfig.callback
                                ]
                            ],
                            "oauth2-provider": ["url": TestConfig.loginURL.absoluteString]
                        ])

        return Config(json: json, options: opts)!
    }

}
