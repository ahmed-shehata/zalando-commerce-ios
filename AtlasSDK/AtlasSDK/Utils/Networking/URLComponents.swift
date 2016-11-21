//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension URLComponents {

    public init(validUrl stringConvertible: URLStringConvertible) {
        self.init(string: stringConvertible.URLString)! // swiftlint:disable:this force_unwrapping
    }

    public init(validUrl stringConvertible: URLStringConvertible, path: String? = nil) {
        self.init(validUrl: stringConvertible)
        if let path = path {
            self.path = path
        }
    }

    public var validUrl: URL {
        return self.url! // swiftlint:disable:this force_unwrapping
    }

}
