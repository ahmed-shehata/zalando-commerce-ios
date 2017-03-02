//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

/// OrderConfirmation struct with the needed properties for the placed order
public struct OrderConfirmation {

    /// Order confirmation number
    public let orderNumber: String

    /// SKU of the requested article by the host app
    /// The one passed to `presentCheckout(onViewController:forSKU:completion)` method
    public let requestedSKU: ConfigSKU

    /// SKU that is used to place the order
    /// This one is different than `requestedSKU` as it contains the size information
    public let purchasedSKU: SimpleSKU

    /// The quantity of the items purchased for the given SKU
    public let quantity: Int

    /// The customer number, would be nil in case the user placed the order as guest
    ///
    /// - Important: Customer number is a sensitive data
    /// - SeeAlso: [Sensitive data](https://github.com/zalando-incubator/atlas-ios/wiki/Sensitive-Data)
    public let customerNumber: CustomerNumber?

    /// Billing Address used by the user to place the order
    ///
    /// - Important: Billing Address is a sensitive data
    /// - SeeAlso: [Sensitive data](https://github.com/zalando-incubator/atlas-ios/wiki/Sensitive-Data)
    public let billingAddress: OrderAddress

    /// Shipping Address used by the user to place the order
    ///
    /// - Important: Shipping Address is a sensitive data
    /// - SeeAlso: [Sensitive data](https://github.com/zalando-incubator/atlas-ios/wiki/Sensitive-Data)
    public let shippingAddress: OrderAddress

    /// Gross Total for the placed order
    public let grossTotal: Money

    /// Tax amount
    public let taxTotal: Money

}

extension OrderConfirmation {

    /// Net amount without Tax
    public var netTotal: Money {
        return Money(amount: grossTotal.amount - taxTotal.amount, currency: grossTotal.currency)
    }

}
