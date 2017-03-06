//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

// TODO: document it, please...

public struct OrderRequest {

    public let checkoutId: CheckoutId

    public init(checkout: Checkout) {
        self.checkoutId = checkout.id
    }

}

extension OrderRequest: JSONRepresentable {

    func toJSON() -> JSONDictionary {
        return [
            "checkout_id": self.checkoutId
        ]
    }

}
