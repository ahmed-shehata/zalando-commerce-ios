//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct GuestCheckout {

    public let shippingAddress: OrderAddress
    public let billingAddress: OrderAddress
    public let cart: GuestCart
    public let payment: GuestPaymentMethod
    public let delivery: Delivery

}

extension GuestCheckout: JSONInitializable {

    private struct Keys {
        static let shippingAddress = "shipping_address"
        static let billingAddress = "billing_address"
        static let cart = "cart"
        static let payment = "payment"
        static let delivery = "delivery"
    }

    init?(json: JSON) {
        guard let
            shippingAddress = OrderAddress(json: json[Keys.shippingAddress]),
            billingAddress = OrderAddress(json: json[Keys.billingAddress]),
            cart = GuestCart(json: json[Keys.cart]),
            payment = GuestPaymentMethod(json: json[Keys.payment]),
            delivery = Delivery(json: json[Keys.delivery])
            else { return nil }

        self.init(shippingAddress: shippingAddress,
                  billingAddress: billingAddress,
                  cart: cart,
                  payment: payment,
                  delivery: delivery)
    }
}
