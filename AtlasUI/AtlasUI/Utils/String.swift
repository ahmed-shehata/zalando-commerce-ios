//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension String {

    var trimmed: String {
        return self.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
    }

}

postfix operator ~? { }

postfix func ~?<T> (val: T?) -> String {
    if let val = val {
        return String(val)
    } else {
        return ""
    }
}
