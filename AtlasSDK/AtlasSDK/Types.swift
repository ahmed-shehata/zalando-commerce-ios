//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

public typealias ModelSKU = String // "XXYYYXYYX"
public typealias ColorSKU = String // "XXYYYXYYX-YYY"
public typealias VariantSKU = String // "XXYYYXYYX-YYYYYYYYYY"

public typealias CartId = String
public typealias CheckoutId = String
public typealias CheckoutToken = String
public typealias CustomerNumber = String

public typealias AddressId = String
public typealias BillingAddress = EquatableAddress
public typealias ShippingAddress = EquatableAddress

public typealias MoneyAmount = Decimal
public typealias Currency = String
