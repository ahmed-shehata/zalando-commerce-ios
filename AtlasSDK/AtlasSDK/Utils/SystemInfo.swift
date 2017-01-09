//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit

struct SystemInfo {

    static var machine: String? {
        var uts = utsname()
        uname(&uts)
        return withUnsafePointer(to: &uts.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in
                String(validatingUTF8: ptr)
            }
        }
    }

    static var platform: String {
        let systemVersion = UIDevice.current.systemVersion
        return "\(machine~?)/\(systemVersion)"
    }

}
