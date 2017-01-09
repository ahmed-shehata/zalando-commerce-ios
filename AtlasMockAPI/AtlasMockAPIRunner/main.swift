//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasMockAPI_macOS

do {
    try AtlasMockAPI.startServer()
} catch let error {
    print(error)
}

while true {
    Thread.sleep(forTimeInterval: 1)
}

