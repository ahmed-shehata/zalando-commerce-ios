//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct IncompleteCheckout: CheckoutType {

    public let id: String
    public let payment: Payment

    public let cartId: String
    public let billingAddress: BillingAddress?
    public let shippingAddress: ShippingAddress?

    init(cartId: String) {
        self.id = ""
        self.cartId = cartId
        self.billingAddress = nil
        self.shippingAddress = nil
        self.payment = Payment()
    }

}
