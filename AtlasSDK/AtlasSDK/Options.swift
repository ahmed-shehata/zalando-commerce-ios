//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct Options {

    public let useSandboxEnvironment: Bool
    public let clientId: String
    public let salesChannel: String
    public let interfaceLanguage: String?
    public let configurationURL: URL

    public init(clientId: String? = nil,
                salesChannel: String? = nil,
                useSandboxEnvironment: Bool? = nil,
                interfaceLanguage: String? = nil,
                configurationURL: URL? = nil,
                infoBundle bundle: Bundle = Bundle.main) {
        self.clientId = clientId ?? bundle.string(for: .clientId) ?? ""
        self.salesChannel = salesChannel ?? bundle.string(for: .salesChannel) ?? ""
        self.useSandboxEnvironment = useSandboxEnvironment ?? bundle.bool(for: .useSandboxEnvironment) ?? false
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
            throw AtlasConfigurationError.missingClientId
        }
        if self.salesChannel.isEmpty {
            throw AtlasConfigurationError.missingSalesChannel
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
            + ", \n\tinterfaceLanguage = \(interfaceLanguage) "
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
