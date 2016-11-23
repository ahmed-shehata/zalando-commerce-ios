//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct Config {

    public let catalogURL: NSURL
    public let checkoutURL: NSURL
    public let checkoutGatewayURL: NSURL
    public let loginURL: NSURL
    public let clientId: String
    public let payment: Payment
    public let salesChannel: SalesChannel
    public let availableSalesChannels: [SalesChannel]

    public let interfaceLocale: NSLocale

    public struct Payment {
        public let selectionCallbackURL: NSURL
        public let thirdPartyCallbackURL: NSURL
    }

    public struct SalesChannel {
        public let identifier: String
        public let locale: NSLocale
        public let termsAndConditionsURL: NSURL

        public var countryCode: String {
            return locale.validCountryCode()
        }
    }

}

extension Config {

    init?(json: JSON, options: Options) {
        guard let
            catalogURL = json["atlas-catalog-api"]["url"].URL,
            checkoutURL = json["atlas-checkout-api"]["url"].URL,
            checkoutGatewayURL = json["atlas-checkout-gateway"]["url"].URL,
            loginURL = json["oauth2-provider"]["url"].URL,
            selectionCallbackURL = json["atlas-checkout-api"]["payment"]["selection-callback"].URL,
            thirdPartyCallbackURL = json["atlas-checkout-api"]["payment"]["third-party-callback"].URL,
            availableSalesChannels = json["sales-channels"].array?.flatMap({ SalesChannel(json: $0) }),
            salesChannel = availableSalesChannels.filter({ $0.identifier == options.salesChannel}).first
            else { return nil }

        self.catalogURL = catalogURL
        self.checkoutURL = checkoutURL
        self.checkoutGatewayURL = checkoutGatewayURL
        self.loginURL = loginURL
        self.availableSalesChannels = availableSalesChannels

        self.payment = Payment(selectionCallbackURL: selectionCallbackURL, thirdPartyCallbackURL: thirdPartyCallbackURL)
        self.salesChannel = salesChannel
        if let interfaceLanguage = options.interfaceLanguage {
            self.interfaceLocale = NSLocale(localeIdentifier: "\(interfaceLanguage)_\(salesChannel.countryCode)")
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
            + ", checkoutGatewayURL: \(self.checkoutGatewayURL)"
            + ", loginURL: \(self.loginURL)"
            + ", clientId: \(self.clientId)"
            + ", salesChannel: \(self.salesChannel)"
            + ", payment: \(self.payment)"
            + ", interfaceLocale: \(self.interfaceLocale.localeIdentifier)"
            + " }"
    }

}

extension Config.SalesChannel: JSONInitializable {

    init?(json: JSON) {
        guard let identifier = json["sales-channel"].string,
            localeIdentifier = json["locale"].string,
            tocURL = json["toc_url"].URL
            else { return nil }

        self.identifier = identifier
        self.locale = NSLocale(localeIdentifier: localeIdentifier)
        self.termsAndConditionsURL = tocURL
    }

}

extension Config.SalesChannel: CustomStringConvertible {

    public var description: String {
        return "SalesChannel: { identifier: \(self.identifier)"
            + ", locale: \(self.locale.localeIdentifier)"
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
