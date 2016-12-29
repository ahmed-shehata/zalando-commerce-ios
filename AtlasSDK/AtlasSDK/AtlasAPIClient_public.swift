//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

/**
 Completion block `AtlasAPIResult` with the no content returned
 */
public typealias NoContentCompletion = (AtlasAPIResult<Bool>) -> Void

/**
 Completion block `AtlasAPIResult` with the `Customer` struct as a success value
 */
public typealias CustomerCompletion = (AtlasAPIResult<Customer>) -> Void

/**
 Completion block `AtlasAPIResult` with the `Cart` struct as a success value
 */
public typealias CartCompletion = (AtlasAPIResult<Cart>) -> Void

/**
 Completion block `AtlasAPIResult` with the `Checkout` struct as a success value
 */
public typealias CheckoutCompletion = (AtlasAPIResult<Checkout>) -> Void

/**
 Completion block `AtlasAPIResult` with the `Checkout` & `Cart` structs as a success value
 */
public typealias CheckoutCartCompletion = (AtlasAPIResult<(checkout: Checkout, cart: Cart)>) -> Void

/**
 Completion block `AtlasAPIResult` with the `Order` struct as a success value
 */
public typealias OrderCompletion = (AtlasAPIResult<Order>) -> Void

/**
 Completion block `AtlasAPIResult` with the `GuestCheckout` struct as a success value
 */
public typealias GuestCheckoutCompletion = (AtlasAPIResult<GuestCheckout>) -> Void

/**
 Completion block `AtlasAPIResult` with the `GuestOrder` struct as a success value
 */
public typealias GuestOrderCompletion = (AtlasAPIResult<GuestOrder>) -> Void

/**
 Completion block `AtlasAPIResult` with the `URL` struct as a success value
 */
public typealias URLCompletion = (AtlasAPIResult<URL>) -> Void

/**
 Completion block `AtlasAPIResult` with the `Article` struct as a success value
 */
public typealias ArticleCompletion = (AtlasAPIResult<Article>) -> Void

/**
 Completion block `AtlasAPIResult` with array of the `UserAddress` struct as a success value
 */
public typealias AddressesCompletion = (AtlasAPIResult<[UserAddress]>) -> Void

/**
 Completion block `AtlasAPIResult` with the `UserAddress` struct as a success value
 */
public typealias AddressCreateUpdateCompletion = (AtlasAPIResult<UserAddress>) -> Void

/**
 Completion block `AtlasAPIResult` with the `CheckAddressResponse` struct as a success value
 */
public typealias CheckAddressCompletion = (AtlasAPIResult<CheckAddressResponse>) -> Void

extension AtlasAPIClient {

    public func customer(completion: @escaping CustomerCompletion) {
        let endpoint = GetCustomerEndpoint(config: config)
        fetch(from: endpoint, completion: completion)
    }

    public func createCart(withItems cartItemRequests: [CartItemRequest], completion: @escaping CartCompletion) {
        let parameters = CartRequest(items: cartItemRequests, replaceItems: true).toJSON()
        let endpoint = CreateCartEndpoint(config: config, parameters: parameters)
        fetch(from: endpoint, completion: completion)
    }

    public func createCheckoutCart(forSKU sku: String, addresses: CheckoutAddresses? = nil, completion: @escaping CheckoutCartCompletion) {
        let cartItemRequest = CartItemRequest(sku: sku, quantity: 1)

        createCart(withItems: [cartItemRequest]) { cartResult in
            switch cartResult {
            case .failure(let error, _):
                completion(.failure(error, nil))

            case .success(let cart):
                let itemExists = cart.items.contains { $0.sku == sku } && !cart.itemsOutOfStock.contains(sku)
                guard itemExists else {
                    completion(.failure(AtlasCheckoutError.outOfStock, nil))
                    return
                }

                self.createCheckout(fromCardId: cart.id, addresses: addresses) { checkoutResult in
                    switch checkoutResult {
                    case .failure(let error, _):
                        if self.isCheckoutFailed(error: error) {
                            let checkoutError = AtlasAPIError.checkoutFailed(cart: cart, error: error)
                            completion(.failure(checkoutError, nil))
                        } else {
                            completion(.failure(error, nil))
                        }
                    case .success(let checkout):
                        completion(.success((checkout: checkout, cart: cart)))
                    }
                }
            }
        }
    }

    public func createCheckout(fromCardId cartId: String, addresses: CheckoutAddresses? = nil, completion: @escaping CheckoutCompletion) {
        let parameters = CreateCheckoutRequest(cartId: cartId, addresses: addresses).toJSON()
        let endpoint = CreateCheckoutEndpoint(config: config, parameters: parameters)
        fetch(from: endpoint, completion: completion)
    }

    public func updateCheckout(withId checkoutId: String,
                               updateCheckoutRequest: UpdateCheckoutRequest,
                               completion: @escaping CheckoutCompletion) {
        let endpoint = UpdateCheckoutEndpoint(config: config, parameters: updateCheckoutRequest.toJSON(), checkoutId: checkoutId)
        fetch(from: endpoint, completion: completion)
    }

    public func createOrder(fromCheckoutId checkoutId: String, completion: @escaping OrderCompletion) {
        let parameters = OrderRequest(checkoutId: checkoutId).toJSON()
        let endpoint = CreateOrderEndpoint(config: config, parameters: parameters, checkoutId: checkoutId)
        fetch(from: endpoint, completion: completion)
    }

    public func createGuestOrder(request: GuestOrderRequest, completion: @escaping GuestOrderCompletion) {
        let endpoint = CompleteGuestOrderEndpoint(config: config, parameters: request.toJSON())
        fetch(from: endpoint, completion: completion)
    }

    public func guestCheckoutPaymentSelectionURL(request: GuestPaymentSelectionRequest, completion: @escaping URLCompletion) {
        let endpoint = CreateGuestOrderEndpoint(config: config, parameters: request.toJSON())
        fetchRedirectLocation(endpoint: endpoint, completion: completion)
    }

    public func guestCheckout(checkoutId: String, token: String, completion: @escaping GuestCheckoutCompletion) {
        let endpoint = GetGuestCheckoutEndpoint(config: config, checkoutId: checkoutId, token: token)
        fetch(from: endpoint, completion: completion)
    }

    public func article(withSKU sku: String, completion: @escaping ArticleCompletion) {
        let endpoint = GetArticleEndpoint(config: config, sku: sku)

        let fetchCompletion: ArticleCompletion = { result in
            if case let .success(article) = result, !article.hasAvailableUnits {
                completion(.failure(AtlasCheckoutError.outOfStock, nil))
            } else {
                completion(result)
            }
        }
        fetch(from: endpoint, completion: fetchCompletion)
    }

    public func addresses(completion: @escaping AddressesCompletion) {
        let endpoint = GetAddressesEndpoint(config: config)
        fetch(from: endpoint, completion: completion)
    }

    public func deleteAddress(withId addressId: String, completion: @escaping NoContentCompletion) {
        let endpoint = DeleteAddressEndpoint(config: config, addressId: addressId)
        touch(endpoint: endpoint, completion: completion)
    }

    public func createAddress(_ request: CreateAddressRequest, completion: @escaping AddressCreateUpdateCompletion) {
        let endpoint = CreateAddressEndpoint(config: config, createAddressRequest: request)
        fetch(from: endpoint, completion: completion)
    }

    public func updateAddress(withAddressId addressId: String,
                              request: UpdateAddressRequest,
                              completion: @escaping AddressCreateUpdateCompletion) {
        let endpoint = UpdateAddressEndpoint(config: config, addressId: addressId, updateAddressRequest: request)
        fetch(from: endpoint, completion: completion)
    }

    public func checkAddress(_ request: CheckAddressRequest, completion: @escaping CheckAddressCompletion) {
        let endpoint = CheckAddressEndpoint(config: config, checkAddressRequest: request)
        fetch(from: endpoint, completion: completion)
    }

}

private extension AtlasAPIClient {

    func isCheckoutFailed(error: Error) -> Bool {
        if case let AtlasAPIError.backend(status, _, _, _) = error, status == 409 {
            return true
        } else {
            return false
        }
    }

}
