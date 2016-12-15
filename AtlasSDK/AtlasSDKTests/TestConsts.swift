//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasMockAPI

struct TestConsts {

    static let clientId: String = "atlas_Y2M1MzA"
    static let useSandboxEnvironment: Bool = true
    static let salesChannel: String = "82fe2e7f-8c4f-4aa1-9019-b6bde5594456"
    static let interfaceLanguage: String = "en"

    static let configURL = AtlasMockAPI.endpointURL(forPath: "/config")
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
