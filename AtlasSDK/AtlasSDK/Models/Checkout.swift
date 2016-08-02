//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasCommons

public struct Checkout {
    public let id: String
    public let customerNumber: String
    public let cartId: String
    public let billingAddressId: String?
    public let shippingAddressId: String?
    public let delivery: Delivery
    public let payment: Payment?
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
        static let delivery = "delivery"
        static let payment = "payment"
    }

    init?(json: JSON) {
        guard let
        id = json[Keys.id].string,
            customerNumber = json[Keys.customerNumber].string,
            cartId = json[Keys.cartId].string,
            delivery = Delivery(json: json[Keys.delivery]) else { return nil }
        self.init(id: id,
            customerNumber: customerNumber,
            cartId: cartId,
            billingAddressId: json[Keys.billingAddressId].string,
            shippingAddressId: json[Keys.shippingAddressId].string,
            delivery: delivery,
            payment: Payment(json: json[Keys.payment]))
    }
}
