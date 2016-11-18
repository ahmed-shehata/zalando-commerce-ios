//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {

    @available(*, deprecated, message: "Check if needed in Swift 3.x")
    mutating func remove<Element: Equatable>(_ item: Element) -> Array {
        self = self.filter { $0 as? Element != item }
        return self
    }

}
