//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension NSURL {

    convenience init(validURL stringConvertible: URLStringConvertible) {
        self.init(string: stringConvertible.URLString)! // swiftlint:disable:this force_unwrapping
    }

    func URLByAppending(pathComponent pathComponent: String) -> NSURL {
        #if swift(>=2.3)
            return self.URLByAppendingPathComponent(pathComponent)! // swiftlint:disable:this force_unwrapping
        #else
            return self.URLByAppendingPathComponent(pathComponent)
        #endif
    }

}
