//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct Order {

    public let orderNumber: String
    public let customerNumber: String
    public let billingAddress: OrderAddress
    public let shippingAddress: OrderAddress
    public let grossTotal: Price
    public let taxTotal: Price
    public let created: NSDate?
    public let detailURL: NSURL?
    public let externalPaymentURL: NSURL?

}

extension Order: JSONInitializable {

    private struct Keys {
        static let orderNumber = "order_number"
        static let customerNumber = "customer_number"
        static let billingAddress = "billing_address"
        static let shippingAddress = "shipping_address"
        static let grossTotal = "gross_total"
        static let taxTotal = "tax_total"
        static let created = "created"
        static let detailUrl = "detail_url"
        static let externalPaymentUrl = "external_payment_url"
    }

    init?(json: JSON) {
        guard let
        orderNumber = json[Keys.orderNumber].string,
            customerNumber = json[Keys.customerNumber].string,
            billingAddress = OrderAddress(json: json[Keys.billingAddress]),
            shippingAddress = OrderAddress(json: json[Keys.shippingAddress]),
            grossTotal = Price(json: json[Keys.grossTotal]),
            taxTotal = Price(json: json[Keys.taxTotal]) else { return nil }

        self.init(orderNumber: orderNumber,
            customerNumber: customerNumber,
            billingAddress: billingAddress,
            shippingAddress: shippingAddress,
            grossTotal: grossTotal,
            taxTotal: taxTotal,
            created: RFC3339DateFormatter().dateFromString(json[Keys.created].string),
            detailURL: json[Keys.detailUrl].URL,
            externalPaymentURL: json[Keys.externalPaymentUrl].URL)
    }
}
