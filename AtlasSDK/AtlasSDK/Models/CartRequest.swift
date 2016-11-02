//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct CartRequest: JSONRepresentable {

    public let items: [CartItemRequest]
    public let replaceItems: Bool

    public init(items: [CartItemRequest], replaceItems: Bool = true) {
        self.items = items
        self.replaceItems = replaceItems
    }

    public func toJSON() -> [String: AnyObject] {
        return [
            "replace_items": self.replaceItems,
            "items": self.items.map { $0.toJSON() }
        ]
    }

}
