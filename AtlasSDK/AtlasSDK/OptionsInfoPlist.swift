//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public extension Options {

    public init(bundle: NSBundle = NSBundle.mainBundle()) {
        self.init(clientId: bundle.string(.clientId),
            salesChannel: bundle.string(.salesChannel),
            useSandbox: bundle.bool(.useSandbox),
            countryCode: bundle.string(.countryCode),
            interfaceLanguage: bundle.string(.interfaceLanguage)
        )
    }

}

extension NSBundle {

    private func string(key: InfoKey, defaultValue: String = "") -> String {
        return self.objectForInfoDictionaryKey(key.rawValue) as? String ?? defaultValue
    }

    private func bool(key: InfoKey, defaultValue: Bool = false) -> Bool {
        return self.objectForInfoDictionaryKey(key.rawValue) as? Bool ?? defaultValue
    }

}
