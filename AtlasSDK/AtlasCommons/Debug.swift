//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

func isDebug() -> Bool {
    #if DEBUG
        return true
    #else
        return false
    #endif
}
