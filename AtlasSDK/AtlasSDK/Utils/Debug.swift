//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct Debug {

    static var isEnabled: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

}
