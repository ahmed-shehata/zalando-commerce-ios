//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension Options {

    enum InfoKey: String {

        case useSandbox = "ATLASSDK_USE_SANDBOX"
        case clientId = "ATLASSDK_CLIENT_ID"
        case salesChannel = "ATLASSDK_SALES_CHANNEL"
        case interfaceLanguage = "ATLASSDK_INTERFACE_LANGUAGE"
        case countryCode = "ATLASSDK_COUNTRY_CODE"

    }

}

extension NSBundle {

    func string(key: Options.InfoKey, defaultValue: String = "") -> String {
        return self.infoObject(forKey: key) ?? defaultValue
    }

    func bool(key: Options.InfoKey, defaultValue: Bool = false) -> Bool {
        return self.infoObject(forKey: key) ?? defaultValue
    }

    func infoObject<T>(forKey key: Options.InfoKey) -> T? {
        return self.objectForInfoDictionaryKey(key.rawValue) as? T
    }

}
