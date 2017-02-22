//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

// swiftlint:disable missing_docs

import Foundation

public struct UpdateCheckoutRequest {

    public let billingAddressId: AddressId?
    public let shippingAddressId: AddressId?

    public init(billingAddressId: AddressId? = nil, shippingAddressId: AddressId? = nil) {
        self.shippingAddressId = shippingAddressId
        self.billingAddressId = billingAddressId
    }

}

extension UpdateCheckoutRequest: JSONRepresentable {

    fileprivate struct Keys {
        static let billingAddressId = "billing_address_id"
        static let shippingAddressId = "shipping_address_id"
    }

    func toJSON() -> JSONDictionary {
        var result = [String: Any]()

        if let billingAddressId = billingAddressId, !billingAddressId.isEmpty {
            result[Keys.billingAddressId] = billingAddressId
        }
        if let shippingAddressId = shippingAddressId, !shippingAddressId.isEmpty {
            result[Keys.shippingAddressId] = shippingAddressId
        }
        return result
    }
}
