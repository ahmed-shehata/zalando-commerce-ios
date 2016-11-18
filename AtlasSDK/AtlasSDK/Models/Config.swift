//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct Config {

    public let catalogURL: URL
    public let checkoutURL: URL
    public let loginURL: URL
    public let clientId: String
    public let payment: Payment
    public let salesChannel: SalesChannel
    public let availableSalesChannels: [SalesChannel]

    public let interfaceLocale: Locale

    public struct Payment {
        public let selectionCallbackURL: URL
        public let thirdPartyCallbackURL: URL
    }

    public struct SalesChannel {
        public let identifier: String
        public let locale: Locale
        public let termsAndConditionsURL: URL

        public var countryCode: String {
            return locale.validCountryCode()
        }
    }

}

extension Config {

    init?(json: JSON, options: Options) {
        guard let catalogURL = json["atlas-catalog-api"]["url"].URL,
            let checkoutURL = json["atlas-checkout-api"]["url"].URL,
            let loginURL = json["oauth2-provider"]["url"].URL,
            let selectionCallbackURL = json["atlas-checkout-api"]["payment"]["selection-callback"].URL,
            let thirdPartyCallbackURL = json["atlas-checkout-api"]["payment"]["third-party-callback"].URL,
            let availableSalesChannels = json["sales-channels"].array?.flatMap({ SalesChannel(json: $0) }),
            let salesChannel = availableSalesChannels.filter({ $0.identifier == options.salesChannel}).first
            else { return nil }

        self.catalogURL = catalogURL
        self.checkoutURL = checkoutURL
        self.loginURL = loginURL
        self.availableSalesChannels = availableSalesChannels

        self.payment = Payment(selectionCallbackURL: selectionCallbackURL, thirdPartyCallbackURL: thirdPartyCallbackURL)
        self.salesChannel = salesChannel
        if let interfaceLanguage = options.interfaceLanguage {
            self.interfaceLocale = Locale(identifier: "\(interfaceLanguage)_\(salesChannel.countryCode)")
        } else {
            self.interfaceLocale = salesChannel.locale
        }

        self.clientId = options.clientId
    }

}

extension Config: CustomStringConvertible {

    public var description: String {
        return "Config: { catalogURL: \(self.catalogURL)"
            + ", checkoutURL: \(self.checkoutURL)"
            + ", loginURL: \(self.loginURL)"
            + ", clientId: \(self.clientId)"
            + ", salesChannel: \(self.salesChannel)"
            + ", payment: \(self.payment)"
            + ", interfaceLocale: \(self.interfaceLocale.identifier)"
            + " }"
    }

}

extension Config.SalesChannel: JSONInitializable {

    init?(json: JSON) {
        guard let identifier = json["sales-channel"].string,
            let localeIdentifier = json["locale"].string,
            let tocURL = json["toc_url"].URL
            else { return nil }

        self.identifier = identifier
        self.locale = Locale(identifier: localeIdentifier)
        self.termsAndConditionsURL = tocURL
    }

}

extension Config.SalesChannel: CustomStringConvertible {

    public var description: String {
        return "SalesChannel: { identifier: \(self.identifier)"
            + ", locale: \(self.locale.identifier)"
            + ", termsAndConditionsURL: \(self.termsAndConditionsURL)"
            + ", countryCode: \(self.countryCode)"
            + " }"
    }

}

extension Config.Payment: CustomStringConvertible {

    public var description: String {
        return "Payment: { selectionCallbackURL: \(self.selectionCallbackURL)"
            + ", thirdPartyCallbackURL: \(self.thirdPartyCallbackURL)"
            + " }"
    }

}
