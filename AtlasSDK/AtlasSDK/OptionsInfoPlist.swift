//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public extension Options {

    public init(bundle: NSBundle) {
        self.init(clientId: bundle.string(.clientId) ?? "",
            salesChannel: bundle.string(.salesChannel) ?? "",
            useSandbox: bundle.bool(.useSandbox) ?? false,
            countryCode: bundle.string(.countryCode) ?? "",
            interfaceLanguage: bundle.string(.interfaceLanguage) ?? ""
        )
    }

}

extension NSBundle {

    private func string(key: InfoKey) -> String? {
        return self.objectForInfoDictionaryKey(key.rawValue) as? String
    }

    private func bool(key: InfoKey) -> Bool? {
        return self.objectForInfoDictionaryKey(key.rawValue) as? Bool
    }

}
