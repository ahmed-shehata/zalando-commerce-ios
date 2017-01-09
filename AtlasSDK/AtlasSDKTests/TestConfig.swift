//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasMockAPI

@testable import AtlasSDK

extension Config {

    static func jsonForTests(options: Options = Options.forTests()) -> JSON {
        return JSON([
            "sales-channels": [
                ["locale": "es_ES", "sales-channel": "SPAIN", "toc_url": "https://www.zalando.es/cgc/"],
                ["locale": TestConsts.configLocale,
                 "sales-channel": options.salesChannel,
                 "toc_url": TestConsts.tocURL],
            ],
            "atlas-catalog-api": ["url": TestConsts.catalogURL.absoluteString],
            "atlas-checkout-gateway": ["url": TestConsts.gateway],
            "atlas-checkout-api": [
                "url": TestConsts.checkoutURL.absoluteString,
                "payment": [
                    "selection-callback": TestConsts.callback,
                    "third-party-callback": TestConsts.callback
                ]
            ],
            "oauth2-provider": ["url": TestConsts.loginURL.absoluteString]
            ])
    }

    static func forTests(options: Options = Options.forTests()) -> Config {
        return Config(json: jsonForTests(options: options), options: options)!
    }

}
