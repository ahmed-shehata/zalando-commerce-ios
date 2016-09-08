//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension String {

    var trimmed: String {
        return stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
    }

    var length: Int {
        return trimmed.characters.count
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
