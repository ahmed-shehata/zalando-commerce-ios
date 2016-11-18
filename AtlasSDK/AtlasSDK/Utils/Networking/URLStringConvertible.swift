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

extension URL: URLStringConvertible {

    public var URLString: String {
        return absoluteString
    }

}

extension URLComponents: URLStringConvertible {

    public var URLString: String {
        return validUrl.URLString
    }

}
