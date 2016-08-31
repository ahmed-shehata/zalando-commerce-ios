//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct IncompleteCheckout: CheckoutType {
    public let id: String
    public let customerNumber: String
    public let cartId: String
    public let billingAddressId: String?
    public let shippingAddressId: String?
    public let billingAddress: BillingAddress?
    public let shippingAddress: ShippingAddress?
    public let delivery: Delivery
    public let payment: Payment

    public func isValid () -> Bool {
        return billingAddressId != nil && shippingAddressId != nil
    }

    init() {
        id = ""
        customerNumber = ""
        cartId = ""
        delivery = Delivery(earliest: "", latest: "")
        payment = Payment(selected: nil, externalPayment: nil, selectionPageUrl: nil)
        billingAddressId = nil
        billingAddress = nil
        shippingAddressId = nil
        shippingAddress = nil 
    }

}