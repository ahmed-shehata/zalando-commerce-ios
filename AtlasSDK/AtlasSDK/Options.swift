//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

// TODO: document it, please...

public struct Options {

    public let useSandboxEnvironment: Bool
    public let clientId: String
    public let salesChannel: String
    public let interfaceLanguage: String?
    public let configurationURL: URL
    public let displayRecommendations: Bool

    public init(clientId: String? = nil,
                salesChannel: String? = nil,
                useSandboxEnvironment: Bool? = nil,
                interfaceLanguage: String? = nil,
                configurationURL: URL? = nil,
                displayRecommendations: Bool = true,
                infoBundle bundle: Bundle = Bundle.main) {
        self.clientId = clientId ?? bundle.string(for: .clientId) ?? ""
        self.salesChannel = salesChannel ?? bundle.string(for: .salesChannel) ?? ""
        self.useSandboxEnvironment = useSandboxEnvironment ?? bundle.bool(for: .useSandboxEnvironment) ?? false
        self.interfaceLanguage = interfaceLanguage ?? bundle.string(for: .interfaceLanguage)
        self.displayRecommendations = displayRecommendations

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
            + ", \n\tdisplayRecommendations = \(displayRecommendations) "
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

        case useSandboxEnvironment = "ATLASSDK_USE_SANDBOX"
        case clientId = "ATLASSDK_CLIENT_ID"
        case salesChannel = "ATLASSDK_SALES_CHANNEL"
        case interfaceLanguage = "ATLASSDK_INTERFACE_LANGUAGE"

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
