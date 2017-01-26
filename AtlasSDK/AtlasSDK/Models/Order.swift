//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct Order {

    public let orderNumber: String
    public let customerNumber: String
    public let billingAddress: OrderAddress
    public let shippingAddress: OrderAddress
    public let grossTotal: Money
    public let taxTotal: Money
    public let created: Date?
    public let detailURL: URL?
    public let externalPaymentURL: URL?

}

extension Order: JSONInitializable {

    fileprivate struct Keys {
        static let orderNumber = "order_number"
        static let customerNumber = "customer_number"
        static let billingAddress = "billing_address"
        static let shippingAddress = "shipping_address"
        static let grossTotal = "gross_total"
        static let taxTotal = "tax_total"
        static let created = "created"
        static let detailURL = "detail_url"
        static let externalPaymentURL = "external_payment_url"
    }

    init?(json: JSON) {
        guard let orderNumber = json[Keys.orderNumber].string,
            let customerNumber = json[Keys.customerNumber].string,
            let billingAddress = OrderAddress(json: json[Keys.billingAddress]),
            let shippingAddress = OrderAddress(json: json[Keys.shippingAddress]),
            let grossTotal = Money(json: json[Keys.grossTotal]),
            let taxTotal = Money(json: json[Keys.taxTotal])
            else { return nil }

        self.init(orderNumber: orderNumber,
                  customerNumber: customerNumber,
                  billingAddress: billingAddress,
                  shippingAddress: shippingAddress,
                  grossTotal: grossTotal,
                  taxTotal: taxTotal,
                  created: json[Keys.created].date,
                  detailURL: json[Keys.detailURL].url,
                  externalPaymentURL: json[Keys.externalPaymentURL].url)
    }
}
