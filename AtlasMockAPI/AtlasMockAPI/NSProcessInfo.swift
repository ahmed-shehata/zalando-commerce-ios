//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public extension NSProcessInfo {

    public static var hasMockedAPIEnabled: Bool {
        return NSProcessInfo.processInfo().arguments.contains(AtlasMockAPI.isEnabledFlag)
    }

}
