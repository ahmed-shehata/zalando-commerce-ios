//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

// swiftlint:disable missing_docs

import Foundation

public struct GuestCart {
    public let items: [CartItem]
    public let itemsOutOfStock: [SimpleSKU]
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
        self.init(items: json[Keys.items].jsons.flatMap { CartItem(json: $0) },
                  itemsOutOfStock: json[Keys.itemsOutOfStock].jsons
                    .flatMap({ $0.string })
                    .map { SimpleSKU(value: $0) },
                  grossTotal: grossTotal,
                  taxTotal: taxTotal)
    }
}
