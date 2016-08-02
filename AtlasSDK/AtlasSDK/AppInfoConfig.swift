//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

enum InfoKey: String {

    case useSandbox = "ATLASSDK_USE_SANDBOX"
    case clientId = "ATLASSDK_CLIENT_ID"
    case salesChannel = "ATLASSDK_SALES_CHANNEL"

}

extension NSBundle {

    private func infoObject<T>(forKey key: InfoKey) -> T? {
        return self.objectForInfoDictionaryKey(key.rawValue) as? T
    }

}
