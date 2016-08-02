//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public extension Options {

    public init(bundle: NSBundle) {
        self.init(clientId: bundle.string(.clientId) ?? "",
            salesChannel: bundle.string(.salesChannel) ?? "",
            useSandbox: bundle.bool(.useSandbox, defaultValue: false))
    }

}

extension NSBundle {

    private func string(key: InfoKey) -> String? {
        return self.objectForInfoDictionaryKey(key.rawValue) as? String
    }

    private func bool(key: InfoKey, defaultValue: Bool = false) -> Bool {
        return self.objectForInfoDictionaryKey(key.rawValue) as? Bool ?? defaultValue
    }

}
