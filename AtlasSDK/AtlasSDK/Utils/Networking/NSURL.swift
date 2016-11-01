//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension NSURL {

    public convenience init(validURL stringConvertible: URLStringConvertible) {
        self.init(string: stringConvertible.URLString)! // swiftlint:disable:this force_unwrapping
    }

    public convenience init(validURL stringConvertible: URLStringConvertible, path: String?) {
        self.init(validURL: NSURLComponents(validURL: stringConvertible, path: path))
    }

    func URLByAppending(pathComponent pathComponent: String) -> NSURL {
        #if swift(>=2.3)
            return self.URLByAppendingPathComponent(pathComponent)! // swiftlint:disable:this force_unwrapping
        #else
            return self.URLByAppendingPathComponent(pathComponent)
        #endif
    }

}
