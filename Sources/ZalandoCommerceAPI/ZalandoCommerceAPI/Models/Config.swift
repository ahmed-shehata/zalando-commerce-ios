//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

/**
 The Configuration struct used to configure the app
 Most properties are returned from the config Endpoint
 */
public struct Config {

    /// The base URL that should be used when calling any Catalog endpoint
    public let catalogURL: URL

    /// The base URL that should be used when calling any Checkout endpoint
    public let checkoutURL: URL

    /// The base URL that should be used when calling any Checkout Gateway endpoint
    public let checkoutGatewayURL: URL

    /// The login URL that should be used in a webview to allow the user to login with his Zalando account
    public let loginURL: URL


    /// The partner's client ID
    public let clientId: String

    /// Boolean flag indicates whether the Sandbox or live environment are turned on
    public let useSandboxEnvironment: Bool

    /// Boolean flag indicates whether the current partner is allowed to checkout as guest checkout or not
    public let guestCheckoutEnabled: Bool

    /** 
     Boolean flag that is taken from the Options that is used to configure the SDK
     
     - SeeAlso: `ZalandoCommerceAPI.Options`
    */
    public let useRecommendations: Bool


    /// Payment redirect URLs Stuct
    public let payment: Payment

    /// The current sales channel
    public let salesChannel: SalesChannel

    /// All the available sales channels for the given client ID
    public let availableSalesChannels: [SalesChannel]


    /** 
     Locale contains the current country and language information, It is fetched from the Options that is used to configure the SDK 
     and also from the Saleschannel used
     
     - SeeAlso: `ZalandoCommerceAPI.Options`
     */
    public let interfaceLocale: Locale

}

extension Config {

    /// Payment redirect URLs Stuct
    public struct Payment {

        /// The URL that the webview will be redirected to after the payment selection is done
        public let selectionCallbackURL: URL

        /// The URL that the webview will be redirected to after the user finish with the 3rd party payments (ex: paypal)
        public let thirdPartyCallbackURL: URL
    }

    /// Sales Channel Struct
    public struct SalesChannel {

        /// Sales Channel ID
        public let identifier: String

        /// Sales Channel Locale containing the supporting country and langauge
        public let locale: Locale

        /// The URL for the Terms and Condition page
        public let termsAndConditionsURL: URL

        /// Country code fetched from `SalesChannel.locale`
        public var countryCode: String {
            return locale.regionCode~?
        }

        /// Language code fetched from `SalesChannel.locale`
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

        if let interfaceLanguage = options.interfaceLanguage {
            self.interfaceLocale = Locale(identifier: "\(interfaceLanguage)_\(salesChannel.countryCode)")
        } else {
            self.interfaceLocale = salesChannel.locale
        }

        self.clientId = options.clientId
        self.useSandboxEnvironment = options.useSandboxEnvironment
        self.useRecommendations = options.useRecommendations
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
            + ", useRecommendations: \(self.useRecommendations)"
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
