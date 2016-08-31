//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public protocol CheckoutType {

    var id: String { get }
    var payment: Payment { get }

    var cartId: String { get }
    var billingAddress: BillingAddress? { get }
    var shippingAddress: ShippingAddress? { get }

    func isValid() -> Bool

}

extension CheckoutType {

    public func isValid() -> Bool {
        return billingAddress != nil && shippingAddress != nil && !id.isEmpty
    }

}
