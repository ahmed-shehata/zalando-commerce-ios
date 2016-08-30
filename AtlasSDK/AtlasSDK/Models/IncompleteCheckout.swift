//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct IncompleteCheckout {
    public let cartId: String?
    public let billingAddressId: String?
    public let shippingAddressId: String?
    public let billingAddress: BillingAddress?
    public let shippingAddress: ShippingAddress?

    public func isValid () -> Bool {
        return billingAddressId != nil && shippingAddressId != nil && cartId != nil
    }

}