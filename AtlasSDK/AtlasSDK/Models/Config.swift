//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

// TODO: document it, please...

public struct Config {

    public let catalogURL: URL
    public let checkoutURL: URL
    public let checkoutGatewayURL: URL
    public let loginURL: URL

    public let clientId: String
    public let useSandboxEnvironment: Bool
    public let guestCheckoutEnabled: Bool

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
            return locale.regionCode~?
        }

        public var languageCode: String {
            return locale.languageCode~?
        }

    }

}

extension Config {

    var authorizationToken: String? {
        return APIAccessToken.retrieve(for: self)
    }

}

extension Config {

    init?(json: JSON, options: Options) {
        let availableSalesChannels = json["sales-channels"].jsons.flatMap({ SalesChannel(json: $0) })
        guard let catalogURL = json["atlas-catalog-api", "url"].url,
            let checkoutURL = json["atlas-checkout-api", "url"].url,
            let checkoutGatewayURL = json["atlas-checkout-gateway", "url"].url,
            let loginURL = json["oauth2-provider", "url"].url,
            let selectionCallbackURL = json["atlas-checkout-api", "payment", "selection-callback"].url,
            let thirdPartyCallbackURL = json["atlas-checkout-api", "payment", "third-party-callback"].url,
            let salesChannel = availableSalesChannels.first(where: { $0.identifier == options.salesChannel })
            else { return nil }

        self.catalogURL = catalogURL
        self.checkoutURL = checkoutURL
        self.checkoutGatewayURL = checkoutGatewayURL
        self.loginURL = loginURL
        self.availableSalesChannels = availableSalesChannels

        self.payment = Payment(selectionCallbackURL: selectionCallbackURL, thirdPartyCallbackURL: thirdPartyCallbackURL)
        self.salesChannel = salesChannel
        self.guestCheckoutEnabled = json["atlas-guest-checkout-api", "enabled"].bool ?? false

        self.clientId = options.clientId
        self.useSandboxEnvironment = options.useSandboxEnvironment
        if let interfaceLanguage = options.interfaceLanguage {
            self.interfaceLocale = Locale(identifier: "\(interfaceLanguage)_\(salesChannel.countryCode)")
        } else {
            self.interfaceLocale = salesChannel.locale
        }

    }

}

extension Config: CustomStringConvertible {

    public var description: String {
        return "Config: { catalogURL: \(self.catalogURL)"
            + ", checkoutURL: \(self.checkoutURL)"
            + ", checkoutGatewayURL: \(self.checkoutGatewayURL)"
            + ", loginURL: \(self.loginURL)"
            + ", clientId: \(self.clientId)"
            + ", salesChannel: \(self.salesChannel)"
            + ", payment: \(self.payment)"
            + ", interfaceLocale: \(self.interfaceLocale.identifier)"
            + ", useSandboxEnvironment: \(self.useSandboxEnvironment)"
            + ", guestCheckoutEnabled: \(self.guestCheckoutEnabled)"
            + " }"
    }

}

extension Config.SalesChannel: JSONInitializable {

    init?(json: JSON) {
        guard let identifier = json["sales-channel"].string,
            let localeIdentifier = json["locale"].string,
            let tocURL = json["toc_url"].url
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
