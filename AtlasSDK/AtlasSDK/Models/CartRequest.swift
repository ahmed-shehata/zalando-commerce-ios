//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasCommons

public struct CartRequest: JSONRepresentable {

    public let salesChannel: String
    public let items: [CartItemRequest]
    public let replaceItems: Bool

    public init(salesChannel: String, items: [CartItemRequest], replaceItems: Bool = true) {
        self.salesChannel = salesChannel
        self.items = items
        self.replaceItems = replaceItems
    }

    public func toJSON() -> [String: AnyObject] {
        return [
            "sales_channel": self.salesChannel,
            "replace_items": self.replaceItems,
            "items": self.items.map { $0.toJSON() }
        ]
    }

}
