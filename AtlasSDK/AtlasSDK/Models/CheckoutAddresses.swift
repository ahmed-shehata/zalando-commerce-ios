//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

// TODO: document it, please...

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
