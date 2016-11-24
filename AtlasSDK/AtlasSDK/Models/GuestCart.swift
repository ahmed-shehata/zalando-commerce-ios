//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct GuestCart {
    public let items: [CartItem]
    public let itemsOutOfStock: [String]
}

extension GuestCart: JSONInitializable {

    private struct Keys {
        static let items = "items"
        static let itemsOutOfStock = "items_out_of_stock"
    }

    init?(json: JSON) {
        self.init(items: json[Keys.items].arrayValue.flatMap { CartItem(json: $0) },
                  itemsOutOfStock: json[Keys.itemsOutOfStock].arrayValue.flatMap { $0.string })
    }
}
