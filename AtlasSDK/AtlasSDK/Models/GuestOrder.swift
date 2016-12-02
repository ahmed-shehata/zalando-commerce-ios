//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct GuestOrder {

    public let orderNumber: String
    public let billingAddress: OrderAddress
    public let shippingAddress: OrderAddress
    public let grossTotal: Price
    public let taxTotal: Price
    public let created: NSDate?
    public let externalPaymentURL: NSURL?

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
        guard let
            orderNumber = json[Keys.orderNumber].string,
            billingAddress = OrderAddress(json: json[Keys.billingAddress]),
            shippingAddress = OrderAddress(json: json[Keys.shippingAddress]),
            grossTotal = Price(json: json[Keys.grossTotal]),
            taxTotal = Price(json: json[Keys.taxTotal]) else { return nil }

        self.init(orderNumber: orderNumber,
                  billingAddress: billingAddress,
                  shippingAddress: shippingAddress,
                  grossTotal: grossTotal,
                  taxTotal: taxTotal,
                  created: RFC3339DateFormatter().dateFromString(json[Keys.created].string),
                  externalPaymentURL: json[Keys.externalPaymentUrl].URL)
    }

}
