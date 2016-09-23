//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension NSURLComponents {

    convenience init(validURL stringConvertible: URLStringConvertible) {
        self.init(string: stringConvertible.URLString)! // swiftlint:disable:this force_unwrapping
    }

    var validURL: NSURL {
        return self.URL! // swiftlint:disable:this force_unwrapping
    }

}
