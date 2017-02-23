//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//


import Foundation

public struct GuestOrder {

    public let orderNumber: String
    public let billingAddress: OrderAddress
    public let shippingAddress: OrderAddress
    public let grossTotal: Money
    public let taxTotal: Money
    public let created: Date?
    public let externalPaymentURL: URL?

}

extension GuestOrder: JSONInitializable {

    private struct Keys {
        static let orderNumber = "order_number"
        static let billingAddress = "billing_address"
        static let shippingAddress = "shipping_address"
        static let grossTotal = "gross_total"
        static let taxTotal = "tax_total"
        static let created = "created"
        static let externalPaymentUrl = "external_payment_url"
    }

    init?(json: JSON) {
        guard let orderNumber = json[Keys.orderNumber].string,
            let billingAddress = OrderAddress(json: json[Keys.billingAddress]),
            let shippingAddress = OrderAddress(json: json[Keys.shippingAddress]),
            let grossTotal = Money(json: json[Keys.grossTotal]),
            let taxTotal = Money(json: json[Keys.taxTotal])
            else { return nil }

        self.init(orderNumber: orderNumber,
                  billingAddress: billingAddress,
                  shippingAddress: shippingAddress,
                  grossTotal: grossTotal,
                  taxTotal: taxTotal,
                  created: json[Keys.created].date,
                  externalPaymentURL: json[Keys.externalPaymentUrl].url)
    }

}
