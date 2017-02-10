//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

// swiftlint:disable missing_docs

import Foundation

public typealias BillingAddress = EquatableAddress
public typealias ShippingAddress = EquatableAddress

public struct CheckoutAddresses {

    public let billingAddress: BillingAddress?
    public let shippingAddress: ShippingAddress?

    public init(shippingAddress: ShippingAddress?, billingAddress: BillingAddress?, autoFill: Bool = false) {
        if autoFill {
            let standardShippingAddress = shippingAddress?.isBillingAllowed == true ? shippingAddress : nil
            self.billingAddress = billingAddress ?? standardShippingAddress
            self.shippingAddress = shippingAddress ?? billingAddress
        } else {
            self.billingAddress = billingAddress
            self.shippingAddress = shippingAddress
        }
    }

}
