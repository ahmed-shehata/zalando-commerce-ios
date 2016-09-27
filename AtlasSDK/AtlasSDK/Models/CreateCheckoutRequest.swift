//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct CreateCheckoutRequest: JSONRepresentable {

    public let cartId: String
    public let billingAddressId: String?
    public let shippingAddressId: String?

    public init(cartId: String, addresses: CheckoutAddresses? = nil) {
        self.cartId = cartId
        self.billingAddressId = addresses?.billingAddress?.id
        self.shippingAddressId = addresses?.shippingAddress?.id
    }

    public func toJSON() -> [String: AnyObject] {
        var json: [String: AnyObject] = [:]
        json["cart_id"] = self.cartId

        if let billingId = self.billingAddressId {
            json["billing_address_id"] = billingId
        }

        if let shippingId = self.shippingAddressId {
            json["shipping_address_id"] = shippingId
        }

        return json
    }

}
