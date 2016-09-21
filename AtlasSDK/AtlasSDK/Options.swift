//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct Options {

    public let useSandboxEnvironment: Bool
    public let clientId: String
    public let interfaceLanguage: String?
    public let countryCode: String
    public let configurationURL: NSURL

    public var localeIdentifier: String {
        return "\(interfaceLanguage ?? "")_\(countryCode)"
    }

    @available( *, deprecated, message = "Should be taken from config service, when ready")
    public let salesChannel: String

    public init(clientId: String,
        salesChannel: String,
        useSandbox: Bool = false,
        countryCode: String,
        interfaceLanguage: String? = nil,
        configurationURL: NSURL? = nil,
        authorizationHandler: AtlasAuthorizationHandler? = nil) {
            self.clientId = clientId
            self.salesChannel = salesChannel
            self.useSandboxEnvironment = useSandbox
            self.countryCode = countryCode
            self.interfaceLanguage = interfaceLanguage

            if let authorizationHandler = authorizationHandler {
                Injector.register { authorizationHandler as AtlasAuthorizationHandler }
            }

            if let url = configurationURL {
                self.configurationURL = url
            } else {
                self.configurationURL = Options.defaultConfigurationURL(clientId: self.clientId, useSandbox: self.useSandboxEnvironment)
            }
    }

    public func validate() throws {
        if self.clientId.isEmpty {
            throw AtlasConfigurationError.missingClientId
        }
        if self.salesChannel.isEmpty {
            throw AtlasConfigurationError.missingSalesChannel
        }
        if self.countryCode.isEmpty {
            throw AtlasConfigurationError.missingCountryCode
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
