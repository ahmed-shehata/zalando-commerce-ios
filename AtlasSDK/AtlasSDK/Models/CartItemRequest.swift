//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

// swiftlint:disable missing_docs

import Foundation

public struct CartItemRequest {

    public let sku: String
    public let quantity: Int

    public init(sku: String, quantity: Int) {
        self.sku = sku
        self.quantity = quantity
    }

}

extension CartItemRequest: JSONRepresentable {

    func toJSON() -> JSONDictionary {
        return [
            "sku": self.sku,
            "quantity": self.quantity
        ]
    }

}
