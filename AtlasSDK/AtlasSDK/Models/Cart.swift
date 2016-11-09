//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct Cart {
    public let id: String
    public let items: [CartItem]
    public let itemsOutOfStock: [String]
    public let delivery: Delivery
    public let grossTotal: Money
    public let taxTotal: Money
}

extension Cart: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
}

public func == (lhs: Cart, rhs: Cart) -> Bool {
    return lhs.id == rhs.id
}

extension Cart: JSONInitializable {

    private struct Keys {
        static let id = "id"
        static let items = "items"
        static let itemsOutOfStock = "items_out_of_stock"
        static let delivery = "delivery"
        static let grossTotal = "gross_total"
        static let taxTotal = "tax_total"
    }

    init?(json: JSON) {
        guard let
        id = json[Keys.id].string,
            delivery = Delivery(json: json[Keys.delivery]),
            grossTotal = Money(json: json[Keys.grossTotal]),
            taxTotal = Money(json: json[Keys.taxTotal]) else { return nil }
        self.init(id: id,
            items: json[Keys.items].arrayValue.flatMap { CartItem(json: $0) },
            itemsOutOfStock: json[Keys.itemsOutOfStock].arrayValue.flatMap { $0.string },
            delivery: delivery,
            grossTotal: grossTotal,
            taxTotal: taxTotal)
    }
}
