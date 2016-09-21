//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct Config {

    public let catalogURL: NSURL
    public let checkoutURL: NSURL
    public let loginURL: NSURL
    public let clientId: String
    public let salesChannel: String

    public let locale: NSLocale

    public var countryCode: String {
        return locale.countryCode
    }

    public var languageCode: String {
        return locale.languageCode
    }

}

private typealias LocaleSalesChannel = (salesChannel: String, locale: String)

extension Config {

    init?(json: JSON, options: Options) {
        guard let
        catalogURL = json["atlas-catalog-api"]["url"].URL,
            checkoutURL = json["atlas-checkout-api"]["url"].URL,
            loginURL = json["oauth2-provider"]["url"].URL,
            localeSalesChannel = Config.localeSalesChannel(json, containingLocaleIdentifier: options.localeIdentifier)
        else { return nil }

        self.catalogURL = catalogURL
        self.checkoutURL = checkoutURL
        self.loginURL = loginURL

        self.salesChannel = localeSalesChannel.salesChannel
        self.locale = NSLocale(localeIdentifier: localeSalesChannel.locale)

        self.clientId = options.clientId
    }

    private static func localeSalesChannel(json: JSON, containingLocaleIdentifier identifier: String) -> LocaleSalesChannel? {
        guard let matchedChannel = firstMatchedChannel(json, containingLocaleIdentifier: identifier),
            salesChannel = matchedChannel["sales-channel"]?.string,
            locale = matchedChannel["locale"]?.string
        else {
            return nil
        }

        return (salesChannel: salesChannel, locale: locale)
    }

    private static func firstMatchedChannel(json: JSON, containingLocaleIdentifier identifier: String) -> [String: JSON]? {
        let channel = json["sales-channels"].arrayValue.filter { channel in
            return channel["locale"].stringValue.lowercaseString.containsString(identifier.lowercaseString)
        }.first
        return channel?.dictionary
    }

}

extension Config: CustomStringConvertible {
    public var description: String {
        return "Config: { catalogURL: \(self.catalogURL)"
            + ", checkoutURL: \(self.checkoutURL)"
            + ", loginURL: \(self.loginURL)"
            + ", salesChannel: \(self.salesChannel)"
            + ", clientId: \(self.clientId)"
            + ", localeIdentifier: \(self.locale.localeIdentifier)"
            + " }"
    }
}
