//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

enum AppLogSeverity: Int {

    case debug, message, error

}

func >= (lhs: AppLogSeverity, rhs: AppLogSeverity) -> Bool {
    return lhs.rawValue >= rhs.rawValue
}
