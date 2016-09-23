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

    public let salesChannelLocale: NSLocale
    public let interfaceLocale: NSLocale

}

private typealias LocaleSalesChannel = (salesChannel: String, locale: String)

extension Config {

    init?(json: JSON, options: Options) {
        guard let
        catalogURL = json["atlas-catalog-api"]["url"].URL,
            checkoutURL = json["atlas-checkout-api"]["url"].URL,
            loginURL = json["oauth2-provider"]["url"].URL,
            localeSalesChannel = Config.findSalesChannel(json, channelId: options.salesChannel)
        else { return nil }

        self.catalogURL = catalogURL
        self.checkoutURL = checkoutURL
        self.loginURL = loginURL

        self.salesChannel = localeSalesChannel.salesChannel
        self.salesChannelLocale = NSLocale(localeIdentifier: localeSalesChannel.locale)

        self.interfaceLocale = options.locale ?? NSLocale(localeIdentifier: localeSalesChannel.locale)

        self.clientId = options.clientId
    }

    private static func findSalesChannel(json: JSON, channelId: String) -> LocaleSalesChannel? {
        guard let matchedChannel = firstMatchedChannel(json, channelId: channelId),
            salesChannel = matchedChannel["sales-channel"]?.string,
            locale = matchedChannel["locale"]?.string
        else {
            return nil
        }

        return (salesChannel: salesChannel, locale: locale)
    }

    private static func firstMatchedChannel(json: JSON, channelId: String) -> [String: JSON]? {
        guard let availableChannels = json["sales-channels"].array else {
            return nil
        }
        let channel = availableChannels.filter { channel in
            return channel["sales-channel"].string?.lowercaseString.containsString(channelId) ?? false
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
            + ", salesChannelLocale: \(self.salesChannelLocale.localeIdentifier)"
            + ", interfaceLocale: \(self.interfaceLocale.localeIdentifier)"
            + " }"
    }
}
