//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension NSURLComponents {

    public convenience init(validURL stringConvertible: URLStringConvertible) {
        self.init(string: stringConvertible.URLString)! // swiftlint:disable:this force_unwrapping
    }

    public convenience init(validURL stringConvertible: URLStringConvertible, path: String?) {
        self.init(validURL: stringConvertible)
        self.path = path
    }

    public var validURL: NSURL {
        return self.URL! // swiftlint:disable:this force_unwrapping
    }

}
