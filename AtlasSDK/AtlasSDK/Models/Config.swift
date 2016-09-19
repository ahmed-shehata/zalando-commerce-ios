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
    public let countryCode: String
    public let authorizationHandler: AtlasAuthorizationHandler?

}

extension Config {

    init?(json: JSON, options: Options) {
        let salesChannel = json["sales-channels"].arrayValue.filter { $0["sales-channel"].stringValue == options.salesChannel }

        guard let
        catalogURL = json["atlas-catalog-api"]["url"].URL,
            checkoutURL = json["atlas-checkout-api"]["url"].URL,
            loginURL = json["oauth2-provider"]["url"].URL,
            countryCode = salesChannel.first?["locale"].string?.componentsSeparatedByString("_").last
        else { return nil }

        self.catalogURL = catalogURL
        self.checkoutURL = checkoutURL
        self.loginURL = loginURL
        self.salesChannel = options.salesChannel
        self.clientId = options.clientId
        self.countryCode = countryCode
        self.authorizationHandler = options.authorizationHandler
    }

}

extension Config {

    init(catalogURL: String, checkoutURL: String, loginURL: String, countryCode: String, options: Options) {
        self.init(catalogURL: NSURL(validUrl: catalogURL),
            checkoutURL: NSURL(validUrl: checkoutURL),
            loginURL: NSURL(validUrl: loginURL),
            countryCode: countryCode,
            options: options)
    }

    init(catalogURL: NSURL, checkoutURL: NSURL, loginURL: NSURL, countryCode: String, options: Options) {
        self.catalogURL = catalogURL
        self.checkoutURL = checkoutURL
        self.loginURL = loginURL
        self.salesChannel = options.salesChannel
        self.clientId = options.clientId
        self.countryCode = countryCode
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
            + ", countryCode: \(self.countryCode)"
            + " }"
    }
}
