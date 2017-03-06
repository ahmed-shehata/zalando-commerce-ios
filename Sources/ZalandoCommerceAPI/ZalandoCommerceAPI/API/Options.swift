//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

/**
Used to initate `AtlasAPI`.

Note: can be fully or partially filled with data from `Info.plist` file.
    More [on wiki](https://github.com/zalando-incubator/atlas-ios/wiki/Configuration)
*/
public struct Options {

    public struct Defaults {
        public static let clientId = ""
        public static let salesChannel = ""
        public static let useSandboxEnvironment = false
        public static let useRecommendations = true
    }

    /**
     Identifier of a client / business entity / app. Required for correct operation,
     provided after access granted.
     [See more](https://zalando-incubator.github.io/checkoutapi-docs/#client)
     */
    public let clientId: String

    /// Identifier of a sales channel. Required for correct operation, provided after access granted.
    /// [See more](https://zalando-incubator.github.io/checkoutapi-docs/#sales-channel)
    public let salesChannel: String

    /// Switches between sandbox and production environment.
    public let useSandboxEnvironment: Bool

    /// Sets language of the interface. Overrides sales channel default language.
    public let interfaceLanguage: String?

    /// Sets config service URL. In regular cases it shouldn't be changed.
    public let configurationURL: URL

    /// Sets if recommendations are handled by the host app.
    public let useRecommendations: Bool

    /**
     Initializes options for `AtlasAPI`.
     
     - Note: Fallback flow:
        1. the value from init
        1. Info.plist
        1. `Options.Default`

     - Parameters:
       - clientId: See `Options.clientId`
       - salesChannel: - See `Options.salesChannel`
       - useSandboxEnvironment: - See `Options.useSandboxEnvironment`
       - interfaceLanguage: - See `Options.interfaceLanguage`
       - configurationURL: - See `Options.configurationURL`
       - useRecommendations: - See `Options.useRecommendations`
       - bundle: bundle to look for `Info.plist` file with Options keys.
     */
    public init(clientId: String? = nil,
                salesChannel: String? = nil,
                useSandboxEnvironment: Bool? = nil,
                interfaceLanguage: String? = nil,
                configurationURL: URL? = nil,
                useRecommendations: Bool? = nil,
                infoBundle bundle: Bundle = Bundle.main) {
        self.clientId = clientId ?? bundle.string(for: .clientId) ?? Defaults.clientId
        self.salesChannel = salesChannel ?? bundle.string(for: .salesChannel) ?? Defaults.salesChannel
        self.useSandboxEnvironment = useSandboxEnvironment ?? bundle.bool(for: .useSandboxEnvironment) ?? Defaults.useSandboxEnvironment
        self.useRecommendations = useRecommendations ?? bundle.bool(for: .useRecommendations) ?? Defaults.useRecommendations
        self.interfaceLanguage = interfaceLanguage ?? bundle.string(for: .interfaceLanguage)

        if let url = configurationURL {
            self.configurationURL = url
        } else {
            self.configurationURL = Options.defaultConfigurationURL(clientId: self.clientId,
                                                                    useSandboxEnvironment: self.useSandboxEnvironment)
        }
    }

    public func validate() throws {
        if self.clientId.isEmpty {
            throw ConfigurationError.missingClientId
        }
        if self.salesChannel.isEmpty {
            throw ConfigurationError.missingSalesChannel
        }
    }

}

extension Options: CustomStringConvertible {

    public var description: String {
        func format(optional text: String?, defaultText: String = "<NONE>") -> String {
            guard let text = text else { return defaultText }
            return "'\(text) '"
        }

        return "\(type(of: self)) { "
            + "\n\tclientId = \(format(optional: clientId)) "
            + ", \n\tuseSandboxEnvironment = \(useSandboxEnvironment) "
            + ", \n\tsalesChannel = \(format(optional: salesChannel)) "
            + ", \n\tinterfaceLanguage = \(format(optional: interfaceLanguage)) "
            + ", \n\tconfigurationURL = \(configurationURL) "
            + ", \n\tdisplayRecommendations = \(useRecommendations) "
            + " } "
    }

}

extension Options {

    enum Environment: String {
        case staging, production

        var isSandbox: Bool { return self == .staging }

        init(useSandboxEnvironment: Bool) {
            self = useSandboxEnvironment ? .staging : .production
        }
    }

    enum ResponseFormat: String {
        case json, yaml, properties
    }

    fileprivate static func defaultConfigurationURL(clientId: String, useSandboxEnvironment: Bool,
                                                    inFormat format: ResponseFormat = .json) -> URL {
        let environment = Environment(useSandboxEnvironment: useSandboxEnvironment)
        let URL = "https://atlas-config-api.dc.zalan.do"
        let path = "/api/config/\(clientId)-\(environment).\(format)"
        return URLComponents(validURL: URL, path: path).validURL
    }

}

extension Options {

    enum InfoKey: String {

        case clientId = "ATLASSDK_CLIENT_ID"
        case salesChannel = "ATLASSDK_SALES_CHANNEL"
        case interfaceLanguage = "ATLASSDK_INTERFACE_LANGUAGE"
        case useSandboxEnvironment = "ATLASSDK_USE_SANDBOX"
        case useRecommendations = "ATLASSDK_USE_RECOMMENDATIONS"

    }

}

extension Bundle {

    func string(for key: Options.InfoKey, defaultValue: String? = nil) -> String? {
        return self.object(forInfoDictionaryKey: key) ?? defaultValue
    }

    func bool(for key: Options.InfoKey, defaultValue: Bool? = nil) -> Bool? {
        return self.object(forInfoDictionaryKey: key) ?? defaultValue
    }

    fileprivate func object<T>(forInfoDictionaryKey key: Options.InfoKey) -> T? {
        return self.object(forInfoDictionaryKey: key.rawValue)
    }

}
