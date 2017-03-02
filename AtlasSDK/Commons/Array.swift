//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

extension Array {

    subscript(safe index: Index?) -> Element? {
        get {
            guard let index = index, (0..<count).contains(index) else { return nil }
            return self[index]
        }
    }

}
