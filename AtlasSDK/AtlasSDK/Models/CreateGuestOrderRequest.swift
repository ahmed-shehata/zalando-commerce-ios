//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct CreateGuestOrderRequest: JSONRepresentable {

    public let customer: Customer
    public let billingAddress: Address
    public let shippingAddress: Address
    public let cart: Cart

    public struct Customer {
        public let email: String
        public let subscribeNewsletter: Bool
    }

    public struct Address {
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

    public struct Cart {
        public let items: [CartItemRequest]
    }

    public init( customer: Customer, billingAddress: Address, shippingAddress: Address, cart: Cart) {
        self.customer = customer
        self.billingAddress = billingAddress
        self.shippingAddress = shippingAddress
        self.cart = cart
    }

    private struct Keys {
        static let customer = "customer"
        static let billingAddress = "billing_address"
        static let shippingAddress = "shipping_address"
        static let cart = "cart"
    }

    public func toJSON() -> [String: AnyObject] {
        return [
            Keys.customer: customer.toJSON(),
            Keys.billingAddress: billingAddress.toJSON(),
            Keys.shippingAddress: shippingAddress.toJSON(),
            Keys.cart: cart.toJSON()
        ]
    }

}

extension CreateGuestOrderRequest.Customer: JSONRepresentable {

    private struct Keys {
        static let email = "email"
        static let subscribeNewsletter = "subscribe_newsletter"
    }

    public func toJSON() -> [String: AnyObject] {
        return [
            Keys.email: email,
            Keys.subscribeNewsletter: subscribeNewsletter
        ]
    }

}

extension CreateGuestOrderRequest.Address: JSONRepresentable {

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

    public func toJSON() -> [String: AnyObject] {
        var json: [String: AnyObject] = [
            Keys.gender: gender.rawValue,
            Keys.firstName: firstName,
            Keys.lastName: lastName,
            Keys.zip: zip,
            Keys.city: city,
            Keys.countryCode: countryCode
        ]
        if let street = street {
            json[Keys.street] = street
        }
        if let additional = additional {
            json[Keys.additional] = additional
        }
        if let pickupPoint = pickupPoint {
            json[Keys.pickupPoint] = pickupPoint.toJSON()
        }
        return json
    }

}

extension CreateGuestOrderRequest.Cart: JSONRepresentable {

    private struct Keys {
        static let items = "items"
    }

    public func toJSON() -> [String: AnyObject] {
        return [Keys.items: self.items.map { $0.toJSON() }]
    }

}
