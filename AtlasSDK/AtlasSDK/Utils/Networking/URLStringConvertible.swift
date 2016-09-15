//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol URLStringConvertible {
    var URLString: String { get }
}

extension String: URLStringConvertible {
    var URLString: String {
        return self
    }
}

extension NSURL: URLStringConvertible {
    var URLString: String {
        #if swift(>=2.3)
            return absoluteString!  // swiftlint:disable:this force_unwrapping
        #else
            return absoluteString
        #endif
    }
}

extension NSURLComponents: URLStringConvertible {
    var URLString: String {
        return validURL.URLString
    }
}
