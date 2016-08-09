//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

/**
 Represents Zalando Config Service Config model
 */
public struct Config {

    let catalogAPIURL: NSURL
    let checkoutAPIURL: NSURL
    let loginURL: NSURL
    let salesChannel: String
    let clientId: String

}

extension Config {

    init?(json: JSON, options: Options) {
        guard let
        catalogAPIURL = json["atlas-catalog-api"]["url"].URL,
            checkoutAPIURL = json["atlas-checkout-api"]["url"].URL,
            loginURL = json["oauth2-provider"]["url"].URL
        else { return nil }

        self.catalogAPIURL = catalogAPIURL
        self.checkoutAPIURL = checkoutAPIURL
        self.loginURL = loginURL
        self.salesChannel = options.salesChannel
        self.clientId = options.clientId
    }

}

extension Config {

    init(catalogAPIURL: String, checkoutAPIURL: String, loginURL: String, options: Options) {
        self.catalogAPIURL = NSURL(validUrl: catalogAPIURL)
        self.checkoutAPIURL = NSURL(validUrl: checkoutAPIURL)
        self.loginURL = NSURL(validUrl: loginURL)
        self.salesChannel = options.salesChannel
        self.clientId = options.clientId
    }

}

extension Config: CustomStringConvertible {
    public var description: String {
        return "Config: { catalogAPIURL: \(self.catalogAPIURL)"
            + ", checkoutAPIURL: \(self.checkoutAPIURL)"
            + ", loginURL: \(self.loginURL)"
            + ", salesChannel: \(self.salesChannel)"
            + ", clientId: \(self.clientId)"
            + " }"
    }
}
