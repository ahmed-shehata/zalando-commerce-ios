//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension String {

    var trimmed: String {
        return stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
    }

    var trimmedLength: Int {
        return trimmed.characters.count
    }

    var length: Int {
        return characters.count
    }

    var oneLineString: String {
        return stringByReplacingOccurrencesOfString("\n", withString: " ")
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
