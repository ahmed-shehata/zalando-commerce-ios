//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct Cart {

    public let id: CartId
    public let items: [CartItem]
    public let itemsOutOfStock: [SimpleSKU]
    public let delivery: Delivery
    public let grossTotal: Money
    public let taxTotal: Money
    public let totalDiscount: Discount?

}

extension Cart {

    public struct Discount {
        public let grossTotal: Money
        public let taxTotal: Money
    }

}

extension Cart: Hashable {

    public var hashValue: Int {
        return id.hashValue
    }

}

public func == (lhs: Cart, rhs: Cart) -> Bool {
    return lhs.id == rhs.id
}

public func == (lhs: Cart.Discount?, rhs: Cart.Discount?) -> Bool {
    return lhs?.grossTotal.amount == rhs?.grossTotal.amount && lhs?.taxTotal.amount == rhs?.taxTotal.amount
}

extension Cart: JSONInitializable {

    private struct Keys {
        static let id = "id"
        static let items = "items"
        static let itemsOutOfStock = "items_out_of_stock"
        static let delivery = "delivery"
        static let grossTotal = "gross_total"
        static let taxTotal = "tax_total"
        static let totalDiscount = "total_discount"
    }

    init?(json: JSON) {
        guard let id = json[Keys.id].string,
            let delivery = Delivery(json: json[Keys.delivery]),
            let grossTotal = Money(json: json[Keys.grossTotal]),
            let taxTotal = Money(json: json[Keys.taxTotal])
            else { return nil }
        self.init(id: id,
                  items: json[Keys.items].jsons.flatMap { CartItem(json: $0) },
                  itemsOutOfStock: json[Keys.itemsOutOfStock].jsons
                    .flatMap({ $0.string })
                    .map { SimpleSKU(value: $0) },
                  delivery: delivery,
                  grossTotal: grossTotal,
                  taxTotal: taxTotal,
                  totalDiscount: Discount(json: json[Keys.totalDiscount]))
    }

}

extension Cart.Discount: JSONInitializable {

    private struct Keys {
        static let grossTotal = "gross_total"
        static let taxTotal = "tax_total"
    }

    init?(json: JSON) {
        guard
            let grossTotal = Money(json: json[Keys.grossTotal]),
            let taxTotal = Money(json: json[Keys.taxTotal])
            else { return nil }

        self.init(grossTotal: grossTotal, taxTotal: taxTotal)
    }

}

extension Cart {

    func hasStock(of sku: SimpleSKU) -> Bool {
        return items.contains { $0.sku == sku } && !itemsOutOfStock.contains(sku)
    }

    func hasStocks(of skus: [SimpleSKU]) -> Bool {
        return skus.filter { !hasStock(of: $0) }.isEmpty
    }

}
