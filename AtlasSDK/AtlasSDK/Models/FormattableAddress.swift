//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public protocol FormattableAddress: StreetAddress {

    var gender: Gender { get }
    var firstName: String { get }
    var lastName: String { get }

    var zip: String { get }
    var city: String { get }
    var countryCode: String { get }

}

public protocol EquatableAddress: FormattableAddress {

    var id: String { get }

}

public func == (lhs: EquatableAddress, rhs: EquatableAddress) -> Bool {

    return lhs.id == rhs.id

}

public typealias BillingAddress = EquatableAddress
public typealias ShippingAddress = EquatableAddress

public typealias CheckoutAddresses = (billingAddress: BillingAddress?, shippingAddress: ShippingAddress?)
