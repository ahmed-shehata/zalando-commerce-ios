//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

enum AnimationDuration: TimeInterval {

    case fast = 0.35
    case normal = 0.5
    case slow = 1

    static let `default` = AnimationDuration.fast

}
