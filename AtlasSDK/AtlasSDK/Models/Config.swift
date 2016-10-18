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
    public let payment: Payment

    public let salesChannelLocale: NSLocale
    public let interfaceLocale: NSLocale

    public var countryCode: String {
        return interfaceLocale.countryCode
    }

    public let tocURL: NSURL

    public struct Payment {
        let selectionCallbackURL: NSURL
        let thirdPartyCallbackURL: NSURL
    }
}

private typealias LocaleSalesChannel = (salesChannel: String, locale: String, tocURL: NSURL)

extension Config {

    init?(json: JSON, options: Options) {
        guard let
            catalogURL = json["atlas-catalog-api"]["url"].URL,
            checkoutURL = json["atlas-checkout-api"]["url"].URL,
            loginURL = json["oauth2-provider"]["url"].URL,
            selectionCallbackURL = json["atlas-checkout-api"]["payment"]["selection-callback"].URL,
            thirdPartyCallbackURL = json["atlas-checkout-api"]["payment"]["third-party-callback"].URL,
            localeSalesChannel = Config.findSalesChannel(json, channelId: options.salesChannel)
        else { return nil }

        self.catalogURL = catalogURL
        self.checkoutURL = checkoutURL
        self.loginURL = loginURL

        self.payment = Payment(selectionCallbackURL: selectionCallbackURL, thirdPartyCallbackURL: thirdPartyCallbackURL)
        self.salesChannel = localeSalesChannel.salesChannel
        self.salesChannelLocale = NSLocale(localeIdentifier: localeSalesChannel.locale)
        self.tocURL = localeSalesChannel.tocURL
        if let interfaceLanguage = options.interfaceLanguage {
            self.interfaceLocale = NSLocale(localeIdentifier: "\(interfaceLanguage)_\(salesChannelLocale.countryCode)")
        } else {
            self.interfaceLocale = salesChannelLocale
        }

        self.clientId = options.clientId
    }

    private static func findSalesChannel(json: JSON, channelId: String) -> LocaleSalesChannel? {
        guard let matchedChannel = firstMatchedChannel(json, channelId: channelId),
            salesChannel = matchedChannel["sales-channel"]?.string,
            locale = matchedChannel["locale"]?.string,
            tocURL = matchedChannel["toc_url"]?.URL
        else {
            return nil
        }

        return (salesChannel: salesChannel, locale: locale, tocURL: tocURL)
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
            + ", tocURL: \(self.tocURL)"
            + " }"
    }
}
