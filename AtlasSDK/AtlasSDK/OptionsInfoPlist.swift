//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

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
