//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension URLComponents {

    init(validURL: URLStringConvertible, path: String? = nil) {
        self.init(string: validURL.urlString)! // swiftlint:disable:this force_unwrapping
        if let path = path {
            self.path = path
        }
    }

    mutating func append(queryItems dict: [String: String?]) {
        let items = dict.map { URLQueryItem(name: $0, value: $1~?) }
        if self.queryItems == nil {
            self.queryItems = items
        } else {
            self.queryItems?.append(contentsOf: items)
        }
    }

    var validURL: URL {
        return self.url! // swiftlint:disable:this force_unwrapping
    }

}
