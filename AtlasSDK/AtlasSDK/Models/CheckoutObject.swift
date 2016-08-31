//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public protocol CheckoutType {

    var id: String { get }
    var customerNumber: String { get }
    var cartId: String { get }

    var delivery: Delivery { get }
    var payment: Payment { get }

    var billingAddressId: String? { get }
    var shippingAddressId: String? { get }
    var billingAddress: BillingAddress? { get }
    var shippingAddress: ShippingAddress? { get }

}

