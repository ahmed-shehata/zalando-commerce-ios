//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct Checkout {
    public let id: String
    public let customerNumber: String
    public let cartId: String
    public let billingAddressId: String?
    public let shippingAddressId: String?
    public let billingAddress: BillingAddress?
    public let shippingAddress: ShippingAddress?
    public let delivery: Delivery
    public let payment: Payment
}

extension Checkout: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
}

public func == (lhs: Checkout, rhs: Checkout) -> Bool {
    return lhs.id == rhs.id
}

extension Checkout: JSONInitializable {

    private struct Keys {
        static let id = "id"
        static let customerNumber = "customer_number"
        static let cartId = "cart_id"
        static let billingAddressId = "billing_address_id"
        static let shippingAddressId = "shipping_address_id"
        static let shippingAddress = "shipping_address"
        static let billingAddress = "billing_address"
        static let delivery = "delivery"
        static let payment = "payment"
    }

    init?(json: JSON) {
        guard let
        id = json[Keys.id].string,
            customerNumber = json[Keys.customerNumber].string,
            cartId = json[Keys.cartId].string,
            payment = Payment(json: json[Keys.payment]),
            delivery = Delivery(json: json[Keys.delivery]) else { return nil }
        self.init(id: id,
            customerNumber: customerNumber,
            cartId: cartId,
            billingAddressId: json[Keys.billingAddressId].string,
            shippingAddressId: json[Keys.shippingAddressId].string,
            billingAddress: BillingAddress(json: json[Keys.billingAddress]),
            shippingAddress: ShippingAddress(json: json[Keys.shippingAddress]),
            delivery: delivery,
            payment: payment)
    }
}
