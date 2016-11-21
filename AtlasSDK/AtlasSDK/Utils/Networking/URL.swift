//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension URL {

    public init(validUrl stringConvertible: URLStringConvertible) {
        self.init(string: stringConvertible.URLString)! // swiftlint:disable:this force_unwrapping
    }

    public init(validUrl stringConvertible: URLStringConvertible, path: String? = nil) {
        self.init(validUrl: URLComponents(validUrl: stringConvertible, path: path))
    }

}
