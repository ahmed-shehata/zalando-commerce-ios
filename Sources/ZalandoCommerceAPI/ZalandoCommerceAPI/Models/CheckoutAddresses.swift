//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

/**
 CheckoutAddresses Struct
 
 Handy struct that contain the addresses needed for the checkout process
*/
public struct CheckoutAddresses {

    /**
     The address used for billing
    */
    public let billingAddress: BillingAddress?

    /** 
     The address used for shipping 
    */
    public let shippingAddress: ShippingAddress?

    /**
     Initialize CheckoutAddresses

     - Parameters:
       - shippingAddress: Shipping address or nil
       - billingAddress: Billing address or nil
       - autoFill: boolean flag if true then will true try to set both the billing and shipping addresses if possible
                   ex: when shippingAddress is nil and billingAddress has value 
                       then the shippingAddress will be also set with the given billingAddress
                   ex: when shippingAddress has value and billingAddress is nil 
                       then the billingAddress will be also set with the given shippingAddress 
                       only if the address is allowed to be used for billing
     */
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
