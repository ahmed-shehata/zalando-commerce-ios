//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct Options {

    public let useSandboxEnvironment: Bool
    public let clientId: String
    public let localeIdentifier: String?
    public let configurationURL: NSURL
    public let salesChannel: String

    internal var locale: NSLocale? {
        guard let localeIdentifier = localeIdentifier else {
            return nil
        }
        return NSLocale(localeIdentifier: localeIdentifier)
    }

    public init(clientId: String? = nil,
        salesChannel: String? = nil,
        useSandbox: Bool? = nil,
        localeIdentifier: String? = nil,
        configurationURL: NSURL? = nil,
        authorizationHandler: AuthorizationHandler? = nil,
        infoBundle bundle: NSBundle = NSBundle.mainBundle()) {
            self.clientId = clientId ?? bundle.string(.clientId) ?? ""
            self.salesChannel = salesChannel ?? bundle.string(.salesChannel) ?? ""
            self.useSandboxEnvironment = useSandbox ?? bundle.bool(.useSandbox) ?? false
            self.localeIdentifier = localeIdentifier ?? bundle.string(.localeIdentifier)

            if let authorizationHandler = authorizationHandler {
                Injector.register { authorizationHandler as AuthorizationHandler }
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
    }

}

extension Options: CustomStringConvertible {

    public var description: String {
        func formatOptional(text: String?, defaultText: String = "<NONE>") -> String {
            guard let text = text else { return defaultText }
            return "'\(text) '"
        }

        return "\(self.dynamicType) { "
            + "\n\tclientId = \(formatOptional(clientId)) "
            + ", \n\tuseSandboxEnvironment = \(useSandboxEnvironment) "
            + ", \n\tsalesChannel = \(formatOptional(salesChannel)) "
            + ", \n\tlocaleIdentifier = \(locale?.localeIdentifier) "
            + " } "
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
            let urlComponents = NSURLComponents(validURL: "https://atlas-config-api.dc.zalan.do/api/config/")
            let basePath = (urlComponents.path ?? "/")

            let environment: Environment = useSandbox ? .staging : .production
            urlComponents.path = "\(basePath)\(clientId)-\(environment).\(format)"
            return urlComponents.validURL
    }

}
