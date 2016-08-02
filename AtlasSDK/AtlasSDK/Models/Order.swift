//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasCommons

public struct Order {

    public struct BillingAddress {
        public let gender: Gender
        public let firstName: String
        public let lastName: String
        public let street: String
        public let additional: String?
        public let zip: String
        public let city: String
        public let countryCode: String
    }

    public struct ShippingAddress {
        public let gender: Gender
        public let firstName: String
        public let lastName: String
        public let street: String?
        public let additional: String?
        public let zip: String
        public let city: String
        public let countryCode: String
        public let pickupPoint: PickupPoint?
    }

    public let orderNumber: String
    public let customerNumber: String
    public let billingAddress: BillingAddress
    public let shippingAddress: ShippingAddress
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
            billingAddress = BillingAddress(json: json[Keys.billingAddress]),
            shippingAddress = ShippingAddress(json: json[Keys.shippingAddress]),
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

extension Order.BillingAddress: JSONInitializable {

    private struct Keys {
        static let gender = "gender"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let street = "street"
        static let additional = "additional"
        static let zip = "zip"
        static let city = "city"
        static let countryCode = "country_code"
    }

    init?(json: JSON) {
        guard let
            genderRaw = json[Keys.gender].string,
            gender = Gender(rawValue: genderRaw),
            firstName = json[Keys.firstName].string,
            lastName = json[Keys.lastName].string,
            street = json[Keys.street].string,
            zip = json[Keys.zip].string,
            city = json[Keys.city].string,
            countryCode = json[Keys.countryCode].string else { return nil }
        self.init(gender: gender,
                  firstName: firstName,
                  lastName: lastName,
                  street: street,
                  additional: json[Keys.additional].string,
                  zip: zip,
                  city: city,
                  countryCode: countryCode)
    }
}

extension Order.ShippingAddress: JSONInitializable {

    private struct Keys {
        static let gender = "gender"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let street = "street"
        static let additional = "additional"
        static let zip = "zip"
        static let city = "city"
        static let countryCode = "country_code"
        static let pickupPoint = "pickup_point"
    }

    init?(json: JSON) {
        guard let
            genderRaw = json[Keys.gender].string,
            gender = Gender(rawValue: genderRaw),
            firstName = json[Keys.firstName].string,
            lastName = json[Keys.lastName].string,
            zip = json[Keys.zip].string,
            city = json[Keys.city].string,
            countryCode = json[Keys.countryCode].string else { return nil }
        let pickupPoint = PickupPoint(json: json[Keys.pickupPoint])
        self.init(gender: gender,
                  firstName: firstName,
                  lastName: lastName,
                  street: json[Keys.street].string,
                  additional: json[Keys.additional].string,
                  zip: zip,
                  city: city,
                  countryCode: countryCode,
                  pickupPoint: pickupPoint)
    }
}
