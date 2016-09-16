//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct Config {

    public let catalogURL: NSURL
    public let checkoutURL: NSURL
    public let loginURL: NSURL
    public let salesChannel: String
    public let clientId: String
    public let authorizationHandler: AtlasAuthorizationHandler?

}

extension Config {

    init?(json: JSON, options: Options) {
        guard let
        catalogURL = json["atlas-catalog-api"]["url"].URL,
            checkoutURL = json["atlas-checkout-api"]["url"].URL,
            loginURL = json["oauth2-provider"]["url"].URL
        else { return nil }

        self.catalogURL = catalogURL
        self.checkoutURL = checkoutURL
        self.loginURL = loginURL
        self.salesChannel = options.salesChannel
        self.clientId = options.clientId
        self.authorizationHandler = options.authorizationHandler
    }

}

extension Config {

    init(catalogURL: String, checkoutURL: String, loginURL: String, options: Options) {
        self.init(catalogURL: NSURL(validURL: catalogURL),
            checkoutURL: NSURL(validURL: checkoutURL),
            loginURL: NSURL(validURL: loginURL),
            options: options)
    }

    init(catalogURL: NSURL, checkoutURL: NSURL, loginURL: NSURL, options: Options) {
        self.catalogURL = catalogURL
        self.checkoutURL = checkoutURL
        self.loginURL = loginURL
        self.salesChannel = options.salesChannel
        self.clientId = options.clientId
        self.authorizationHandler = options.authorizationHandler
    }

}

extension Config: CustomStringConvertible {
    public var description: String {
        return "Config: { catalogURL: \(self.catalogURL)"
            + ", checkoutURL: \(self.checkoutURL)"
            + ", loginURL: \(self.loginURL)"
            + ", salesChannel: \(self.salesChannel)"
            + ", clientId: \(self.clientId)"
            + " }"
    }
}
