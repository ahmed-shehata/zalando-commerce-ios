//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public protocol URLStringConvertible {

    var urlString: String { get }

}

extension String: URLStringConvertible {

    public var urlString: String {
        return self
    }

}

extension URL: URLStringConvertible {

    public var urlString: String {
        return absoluteString
    }

}

extension URLComponents: URLStringConvertible {

    public var urlString: String {
        return validURL.urlString
    }

}
