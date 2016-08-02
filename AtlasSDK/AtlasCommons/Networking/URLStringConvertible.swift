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
        return absoluteString
    }
}

extension NSURLComponents: URLStringConvertible {
    var URLString: String {
        return validURL.URLString
    }
}
