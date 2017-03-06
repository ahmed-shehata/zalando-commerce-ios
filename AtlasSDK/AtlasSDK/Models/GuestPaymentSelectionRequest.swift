//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

// TODO: document it, please...

public struct GuestPaymentSelectionRequest {

    public let cart: GuestCartRequest
    public let customer: GuestCustomerRequest
    public let shippingAddress: GuestAddressRequest
    public let billingAddress: GuestAddressRequest

    public init(cart: GuestCartRequest,
                customer: GuestCustomerRequest,
                shippingAddress: GuestAddressRequest,
                billingAddress: GuestAddressRequest) {

        self.cart = cart
        self.customer = customer
        self.shippingAddress = shippingAddress
        self.billingAddress = billingAddress
    }

}

extension GuestPaymentSelectionRequest: JSONRepresentable {

    private struct Keys {
        static let cart = "cart"
        static let customer = "customer"
        static let shippingAddress = "shipping_address"
        static let billingAddress = "billing_address"
    }

    func toJSON() -> JSONDictionary {
        return [
            Keys.cart: cart.toJSON(),
            Keys.customer: customer.toJSON(),
            Keys.shippingAddress: shippingAddress.toJSON(),
            Keys.billingAddress: billingAddress.toJSON()
        ]
    }

}
