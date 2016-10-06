//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct CheckoutCart {

    public let checkout: Checkout
    public var cart: Cart?

}

extension CheckoutCart: JSONInitializable {

    init?(json: JSON) {
        guard let checkout = Checkout(json: json) else { return nil }
        self.init(checkout: checkout, cart: nil)
    }

}
