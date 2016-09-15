//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct Options {

    public let useSandboxEnvironment: Bool
    public let clientId: String
    public let salesChannel: String
    public let interfaceLanguage: String
    public let configurationURL: NSURL
    public let authorizationHandler: AtlasAuthorizationHandler?

    public init(clientId: String, salesChannel: String, useSandbox: Bool = false,
        interfaceLanguage: String = "de_DE", configurationURL: NSURL? = nil,
        authorizationHandler: AtlasAuthorizationHandler? = nil) {
            self.clientId = clientId
            self.salesChannel = salesChannel
            self.useSandboxEnvironment = useSandbox
            self.interfaceLanguage = interfaceLanguage
            self.authorizationHandler = authorizationHandler

            if let url = configurationURL {
                self.configurationURL = url
            } else {
                self.configurationURL = Options.defaultConfigurationURL(clientId: self.clientId, useSandbox: self.useSandboxEnvironment)
            }
    }

    public init(basedOn options: Options, clientId: String? = nil,
        salesChannel: String? = nil, useSandbox: Bool? = nil,
        interfaceLanguage: String? = nil, configurationURL: NSURL? = nil,
        authorizationHandler: AtlasAuthorizationHandler? = nil) {
            self.clientId = clientId ?? options.clientId
            self.salesChannel = salesChannel ?? options.salesChannel
            self.useSandboxEnvironment = useSandbox ?? options.useSandboxEnvironment
            self.interfaceLanguage = interfaceLanguage ?? options.interfaceLanguage
            self.configurationURL = configurationURL ?? options.configurationURL
            self.authorizationHandler = authorizationHandler ?? options.authorizationHandler
    }

    public func validate() throws {
        if self.clientId.isEmpty {
            throw AtlasConfigurationError.missingClientId
        }
        if self.salesChannel.isEmpty {
            throw AtlasConfigurationError.missingSalesChannel
        }
        if self.interfaceLanguage.isEmpty {
            throw AtlasConfigurationError.missingInterfaceLanguage
        }
        if self.authorizationHandler == nil {
            throw AtlasConfigurationError.missingAuthorizationHandler
        }
    }

}

extension Options: CustomStringConvertible {

    public var description: String {
        func formatOptional(text: String?, defaultText: String = "<NONE>") -> String {
            guard let text = text else { return defaultText }
            return "'\(text)'"
        }

        return "\(self.dynamicType) { "
            + "\n\tclientId = \(formatOptional(clientId))"
            + ",\n\tuseSandboxEnvironment = \(useSandboxEnvironment)"
            + ",\n\tsalesChannel = \(formatOptional(salesChannel))"
            + ",\n\tinterfaceLanguage = \(interfaceLanguage)"
            + " }"
    }

}

extension Options {

    enum Environment: String {
        case staging = "staging"
        case production = "production"
    }

    enum ResponseFormat: String {
        case json = "json"
        case yaml = "yaml"
        case properties = "properties"
    }

    private static func defaultConfigurationURL(clientId clientId: String, useSandbox: Bool,
        inFormat format: ResponseFormat = .json) -> NSURL {
            let urlComponents = NSURLComponents(validUrlString: "https://atlas-config-api.dc.zalan.do/api/config/")
            let basePath = (urlComponents.path ?? "/")

            let environment: Environment = useSandbox ? .staging : .production
            urlComponents.path = "\(basePath)\(clientId)-\(environment).\(format)"
            return urlComponents.validURL
    }

}
