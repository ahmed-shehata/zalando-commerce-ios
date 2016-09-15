//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension NSURLQueryItem {

    convenience init(key: NSURL.QueryItemKey, value: String) {
        self.init(name: key.rawValue, value: value)
    }

    convenience init(key: NSURL.QueryItemKey, value: NSURL.QueryItemValue) {
        self.init(name: key.rawValue, value: value.rawValue)
    }
    
}

