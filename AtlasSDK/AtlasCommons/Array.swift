//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {

    mutating func remove<Element: Equatable>(item: Element) -> Array {
        self = self.filter { $0 as? Element != item }
        return self
    }

}
