//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct GuestPaymentSelectionRequest {

    public let customer: GuestCustomerRequest
    public let shippingAddress: GuestAddressRequest
    public let billingAddress: GuestAddressRequest
    public let cart: GuestCartRequest

    public init(customer: GuestCustomerRequest,
                shippingAddress: GuestAddressRequest,
                billingAddress: GuestAddressRequest,
                cart: GuestCartRequest) {

        self.customer = customer
        self.shippingAddress = shippingAddress
        self.billingAddress = billingAddress
        self.cart = cart
    }

}

extension GuestPaymentSelectionRequest: JSONRepresentable {

    private struct Keys {
        static let customer = "customer"
        static let shippingAddress = "shipping_address"
        static let billingAddress = "billing_address"
        static let cart = "cart"
    }

    public func toJSON() -> [String: Any] {
        return [
            Keys.customer: customer.toJSON(),
            Keys.shippingAddress: shippingAddress.toJSON(),
            Keys.billingAddress: billingAddress.toJSON(),
            Keys.cart: cart.toJSON()
        ]
    }

}
