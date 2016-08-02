//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct Options {

    var useSandboxEnvironment: Bool
    var clientId: String
    var salesChannel: String
    var interfaceLanguage: String

    init() {
        self.init(clientId: "", salesChannel: "")
    }

    public init(clientId: String, salesChannel: String, useSandbox: Bool = false, interfaceLanguage: String = "de_DE") {
        self.clientId = clientId
        self.salesChannel = salesChannel
        self.useSandboxEnvironment = useSandbox
        self.interfaceLanguage = interfaceLanguage
    }

    public func validate() throws {
        if self.clientId.isEmpty {
            throw AtlasConfigurationError(status: .InitFailed, message: "Missing client ID")
        }
        if self.salesChannel.isEmpty {
            throw AtlasConfigurationError(status: .InitFailed, message: "Missing sales channel")
        }
        if self.interfaceLanguage.isEmpty {
            throw AtlasConfigurationError(status: .InitFailed, message: "Missing interface language")
        }
    }

}

extension Options: CustomStringConvertible {

    public var description: String {
        func fmt(text: String?, defaultText: String = "<NONE>") -> String {
            guard let text = text else { return defaultText }
            return "'\(text)'"
        }

        return "\(self.dynamicType) { "
            + "\n\tclientId = \(fmt(clientId))"
            + ",\n\tuseSandboxEnvironment = \(useSandboxEnvironment)"
            + ",\n\tsalesChannel = \(fmt(salesChannel))"
            + " }"
    }

}
