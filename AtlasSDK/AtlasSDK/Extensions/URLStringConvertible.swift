//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

protocol URLStringConvertible {

    var urlString: String { get }

}

extension String: URLStringConvertible {

    var urlString: String {
        return self
    }

}

extension URL: URLStringConvertible {

    var urlString: String {
        return absoluteString
    }

}

extension URLComponents: URLStringConvertible {

    var urlString: String {
        return validURL.urlString
    }

}
