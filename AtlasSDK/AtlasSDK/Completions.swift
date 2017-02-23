//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

public enum AtlasAPIResult<T> {

    case success(T)
    case failure(Error, APIRequest<T>?)
    
}

public typealias AtlasClientCompletion = (AtlasResult<AtlasAPI>) -> Void

public typealias AtlasConfigCompletion = (AtlasAPIResult<Config>) -> Void

/// Completion closure with `Bool` in `AtlasAPIResult.success` result
public typealias SuccessCompletion = (AtlasAPIResult<Bool>) -> Void

/// Completion closure with `Customer` in `AtlasAPIResult.success` result
public typealias CustomerCompletion = (AtlasAPIResult<Customer>) -> Void

/// Completion closure with `Cart` in `AtlasAPIResult.success` result
public typealias CartCompletion = (AtlasAPIResult<Cart>) -> Void

/// Completion closure with `Checkout` in `AtlasAPIResult.success` result
public typealias CheckoutCompletion = (AtlasAPIResult<Checkout>) -> Void

/// Completion closure with (`Checkout`, `Cart`) in `AtlasAPIResult.success` result
public typealias CheckoutCartCompletion = (AtlasAPIResult<(checkout: Checkout, cart: Cart)>) -> Void

/// Completion closure with `Order` in `AtlasAPIResult.success` result
public typealias OrderCompletion = (AtlasAPIResult<Order>) -> Void

/// Completion closure with `GuestCheckout` in `AtlasAPIResult.success` result
public typealias GuestCheckoutCompletion = (AtlasAPIResult<GuestCheckout>) -> Void

/// Completion closure with `GuestOrder` in `AtlasAPIResult.success` result
public typealias GuestOrderCompletion = (AtlasAPIResult<GuestOrder>) -> Void

/// Completion closure with `URL` in `AtlasAPIResult.success` result
public typealias URLCompletion = (AtlasAPIResult<URL>) -> Void

/// Completion closure with `Article` in `AtlasAPIResult.success` result
public typealias ArticleCompletion = (AtlasAPIResult<Article>) -> Void

/// Completion closure with `[UserAddress]` in `AtlasAPIResult.success` result
public typealias AddressesCompletion = (AtlasAPIResult<[UserAddress]>) -> Void

/// Completion closure with `UserAddress` in `AtlasAPIResult.success` result
public typealias AddressChangeCompletion = (AtlasAPIResult<UserAddress>) -> Void

/// Completion closure with `CheckAddressResponse` in `AtlasAPIResult.success` result
public typealias AddressCheckCompletion = (AtlasAPIResult<CheckAddressResponse>) -> Void
