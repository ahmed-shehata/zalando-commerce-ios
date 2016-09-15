//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension NSURL {

    var validAbsoluteString: String {
        #if swift(>=2.3)
            return self.absoluteString! // swiftlint:disable:this force_unwrapping
        #else
            return self.absoluteString
        #endif

    }

}
