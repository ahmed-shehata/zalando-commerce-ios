//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct GuestCart {
    public let items: [CartItem]
    public let itemsOutOfStock: [String]
    public let grossTotal: Money
    public let taxTotal: Money
}

extension GuestCart: JSONInitializable {

    private struct Keys {
        static let items = "items"
        static let itemsOutOfStock = "items_out_of_stock"
        static let grossTotal = "gross_total"
        static let taxTotal = "tax_total"
    }

    init?(json: JSON) {
        guard let grossTotal = Money(json: json[Keys.grossTotal]),
            let taxTotal = Money(json: json[Keys.taxTotal])
            else { return nil }
        self.init(items: json[Keys.items].arrayValue.flatMap { CartItem(json: $0) },
                  itemsOutOfStock: json[Keys.itemsOutOfStock].arrayValue.flatMap { $0.string },
                  grossTotal: grossTotal,
                  taxTotal: taxTotal)
    }
}