//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

postfix operator ~?
infix operator ~?

postfix func ~?<T> (val: T?) -> String {
    if let val = val {
        return String(describing: val)
    } else {
        return ""
    }
}

func ~?<T> (val: T?, fallback: String = "") -> String {
    if let val = val {
        return String(describing: val)
    } else {
        return fallback
    }
}
