//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct GuestCheckout {

    public let customerNumber: String
    public let shippingAddress: OrderAddress
    public let billingAddress: OrderAddress

    public let cart: GuestCart
    public let grossTotal: Price
    public let taxTotal: Price
    public let payment: GuestPaymentMethod

}

extension GuestCheckout: JSONInitializable {

    private struct Keys {
        static let customerNumber = "customer_number"
        static let shippingAddress = "shipping_address"
        static let billingAddress = "billing_address"
        static let cart = "cart"
        static let grossTotal = "gross_total"
        static let taxTotal = "tax_total"
        static let payment = "payment"
    }

    init?(json: JSON) {
        guard let
            customerNumber = json[Keys.customerNumber].string,
            shippingAddress = OrderAddress(json: json[Keys.shippingAddress]),
            billingAddress = OrderAddress(json: json[Keys.billingAddress]),
            cart = GuestCart(json: json[Keys.cart]),
            grossTotal = Price(json: json[Keys.grossTotal]),
            taxTotal = Price(json: json[Keys.taxTotal]),
            payment = GuestPaymentMethod(json: json[Keys.payment])
            else { return nil }

        self.init(customerNumber: customerNumber,
                  shippingAddress: shippingAddress,
                  billingAddress: billingAddress,
                  cart: cart,
                  grossTotal: grossTotal,
                  taxTotal: taxTotal,
                  payment: payment)
    }
}
