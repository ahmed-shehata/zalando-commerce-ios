//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import MockAPI_macOS

do {
    try MockAPI.startServer()
} catch let error {
    print(error)
}

while true {
    Thread.sleep(forTimeInterval: 1)
}

