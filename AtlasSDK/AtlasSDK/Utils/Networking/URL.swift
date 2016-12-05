//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension URL {

    public init(validURL stringConvertible: URLStringConvertible) {
        self.init(string: stringConvertible.urlString)! // swiftlint:disable:this force_unwrapping
    }

    public init(validURL stringConvertible: URLStringConvertible, path: String? = nil) {
        self.init(validURL: URLComponents(validURL: stringConvertible, path: path))
    }

}
