//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasCommons

public struct Order {
    public let orderNumber: String
    public let customerNumber: String
    public let billingAddress: Address
    public let shippingAddress: Address
    public let grossTotal: Price
    public let taxTotal: Price
    public let created: NSDate?
    public let detailUrl: NSURL?
    public let externalPaymentUrl: NSURL?

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
            billingAddress = Address(json: json[Keys.billingAddress]),
            shippingAddress = Address(json: json[Keys.shippingAddress]),
            grossTotal = Price(json: json[Keys.grossTotal]),
            taxTotal = Price(json: json[Keys.taxTotal]) else { return nil }

        self.init(orderNumber: orderNumber,
            customerNumber: customerNumber,
            billingAddress: billingAddress,
            shippingAddress: shippingAddress,
            grossTotal: grossTotal,
            taxTotal: taxTotal,
            created: NSDate(object: json[Keys.created].string, formatter: ISO8601DateFormatter),
            detailUrl: json[Keys.detailUrl].URL,
            externalPaymentUrl: json[Keys.externalPaymentUrl].URL)
    }
}
