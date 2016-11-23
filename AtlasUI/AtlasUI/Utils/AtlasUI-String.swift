//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension String {

    func trimmed() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var length: Int {
        return characters.count
    }

    func onelined() -> String {
        return replacingOccurrences(of: "\n", with: " ")
    }

}

postfix operator ~?

postfix func ~?<T> (val: T?) -> String {
    if let val = val {
        return String(describing: val)
    } else {
        return ""
    }
}
