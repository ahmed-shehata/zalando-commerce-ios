//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public protocol URLStringConvertible {

    var URLString: String { get }

}

extension String: URLStringConvertible {

    public var URLString: String {
        return self
    }

}

extension NSURL: URLStringConvertible {

    public var URLString: String {
        #if swift(>=2.3)
            return absoluteString! // swiftlint:disable:this force_unwrapping
        #else
            return absoluteString
        #endif
    }

}

extension NSURLComponents: URLStringConvertible {

    public var URLString: String {
        return validURL.URLString
    }

}
