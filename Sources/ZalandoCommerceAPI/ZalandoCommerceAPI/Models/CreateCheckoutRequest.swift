//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct CreateCheckoutRequest {

    public let cartId: CartId
    public let billingAddressId: AddressId?
    public let shippingAddressId: AddressId?
    public let coupons: [String]?

    public init(cartId: CartId, addresses: CheckoutAddresses? = nil, coupons: [String]? = nil) {
        self.cartId = cartId
        self.billingAddressId = addresses?.billingAddress?.id
        self.shippingAddressId = addresses?.shippingAddress?.id
        self.coupons = coupons
    }

}

extension CreateCheckoutRequest: JSONRepresentable {

    private struct Keys {
        static let cartId = "cart_id"
        static let coupons = "coupons"
        static let billingAddressId = "billing_address_id"
        static let shippingAddressId = "shipping_address_id"
    }

    func toJSON() -> JSONDictionary {
        return [
            Keys.cartId: cartId,
            Keys.coupons: coupons as Any,
            Keys.billingAddressId: billingAddressId as Any,
            Keys.shippingAddressId: shippingAddressId as Any
        ]
    }

}
