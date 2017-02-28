//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct CartItemRequest {

    public let sku: SimpleSKU
    public let quantity: Int

    public init(sku: SimpleSKU, quantity: Int) {
        self.sku = sku
        self.quantity = quantity
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
