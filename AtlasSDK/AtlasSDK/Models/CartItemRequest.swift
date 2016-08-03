//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct CartItemRequest: JSONRepresentable {

    public let sku: String
    public let quantity: Int

    public init(sku: String, quantity: Int) {
        self.sku = sku
        self.quantity = quantity
    }

    public func toJSON() -> Dictionary<String, AnyObject> {
        return [
            "sku": self.sku,
            "quantity": self.quantity
        ]
    }

}
