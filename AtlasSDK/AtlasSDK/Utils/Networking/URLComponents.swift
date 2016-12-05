//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension URLComponents {

    public init(validURL: URLStringConvertible, path: String? = nil) {
        self.init(string: validURL.urlString)! // swiftlint:disable:this force_unwrapping
        if let path = path {
            self.path = path
        }
    }

    public var validURL: URL {
        return self.url! // swiftlint:disable:this force_unwrapping
    }

}
