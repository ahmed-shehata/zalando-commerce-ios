//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension NSURL {

    convenience init(validUrl stringConvertible: URLStringConvertible) {
        self.init(string: stringConvertible.URLString)! // swiftlint:disable:this force_unwrapping
    }

}
