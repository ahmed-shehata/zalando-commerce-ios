//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct GuestCheckout {

    public let id: String
    public let customerNumber: String
    public let cart: Cart

    public let delivery: Delivery
    public let payment: Payment

    public let billingAddress: CheckoutAddress
    public let shippingAddress: CheckoutAddress

}

extension GuestCheckout: JSONInitializable {

    private struct Keys {
        static let id = "id"
        static let customerNumber = "customer_number"
        static let cart = "cart"
        static let shippingAddress = "shipping_address"
        static let billingAddress = "billing_address"
        static let delivery = "delivery"
        static let payment = "payment"
    }

    init?(json: JSON) {
        guard let
            id = json[Keys.id].string,
            customerNumber = json[Keys.customerNumber].string,
            cart = Cart(json: json[Keys.cart]),
            payment = Payment(json: json[Keys.payment]),
            delivery = Delivery(json: json[Keys.delivery]),
            billingAddress = CheckoutAddress(json: json[Keys.billingAddress]),
            shippingAddress = CheckoutAddress(json: json[Keys.shippingAddress])
            else { return nil }

        self.init(id: id,
                  customerNumber: customerNumber,
                  cart: cart,
                  delivery: delivery,
                  payment: payment,
                  billingAddress: billingAddress,
                  shippingAddress: shippingAddress
        )
    }
}
