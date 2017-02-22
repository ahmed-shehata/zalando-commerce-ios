//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

// swiftlint:disable missing_docs

import Foundation

public struct CreateCheckoutRequest: JSONRepresentable {

    public let cartId: CartId
    public let billingAddressId: AddressId?
    public let shippingAddressId: AddressId?

    public init(cartId: CartId, addresses: CheckoutAddresses? = nil) {
        self.cartId = cartId
        self.billingAddressId = addresses?.billingAddress?.id
        self.shippingAddressId = addresses?.shippingAddress?.id
    }

    func toJSON() -> JSONDictionary {
        var json: [String: Any] = ["cart_id": self.cartId]

        if let billingAddressId = self.billingAddressId {
            json["billing_address_id"] = billingAddressId
        }

        if let shippingAddressId = self.shippingAddressId {
            json["shipping_address_id"] = shippingAddressId
        }

        return json
    }

}
