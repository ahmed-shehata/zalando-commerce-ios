//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct CartItemRequest {

    public let sku: VariantSKU
    public let quantity: Int

    public init(sku: VariantSKU, quantity: Int) {
        self.sku = sku
        self.quantity = quantity
    }

}

extension CartItemRequest {

    init?(variantSKU: String, quantity: Int) {
        guard let sku = VariantSKU(string: variantSKU) else { return nil }
        self.init(sku: sku, quantity: quantity)
    }

}

extension CartItemRequest: JSONRepresentable {

    func toJSON() -> JSONDictionary {
        return [
            "sku": self.sku.value,
            "quantity": self.quantity
        ]
    }

}
