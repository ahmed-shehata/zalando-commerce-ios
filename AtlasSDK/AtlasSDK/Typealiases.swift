//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

// TODO: document it, please...

public typealias CartId = String
public typealias CheckoutId = String
public typealias CustomerNumber = String
public typealias CartCheckout = (cart: Cart, checkout: Checkout?)

public typealias AuthorizationToken = String

public typealias AddressId = String
public typealias BillingAddress = EquatableAddress
public typealias ShippingAddress = EquatableAddress

public typealias MoneyAmount = Decimal
public typealias Currency = String

public typealias GuestCheckoutToken = String
