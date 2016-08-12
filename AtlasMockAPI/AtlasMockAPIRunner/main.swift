//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasMockAPI_macOS

do {
    try AtlasMockAPI.startServer()
} catch let error {
    print(error)
}

while true {
    NSThread.sleepForTimeInterval(1)
}

