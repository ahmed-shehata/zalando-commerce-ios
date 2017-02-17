//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

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

/// Completion closure with array of `Recommendation` in `AtlasAPIResult.success` result
public typealias RecommendationCompletion = (AtlasAPIResult<[Recommendation]>) -> Void

/// Completion closure with array of `UserAddress` in `AtlasAPIResult.success` result
public typealias AddressesCompletion = (AtlasAPIResult<[UserAddress]>) -> Void

/// Completion closure with `UserAddress` in `AtlasAPIResult.success` result
public typealias AddressChangeCompletion = (AtlasAPIResult<UserAddress>) -> Void

/// Completion closure with `CheckAddressResponse` in `AtlasAPIResult.success` result
public typealias AddressCheckCompletion = (AtlasAPIResult<CheckAddressResponse>) -> Void

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

    public func createCheckoutCart(forSelectedArticle selectedArticle: SelectedArticle,
                                   addresses: CheckoutAddresses? = nil,
                                   completion: @escaping CheckoutCartCompletion) {
        let cartItemRequest = CartItemRequest(sku: selectedArticle.sku, quantity: selectedArticle.quantity)

        createCart(withItems: [cartItemRequest]) { cartResult in
            switch cartResult {
            case .failure(let error, _):
                completion(.failure(error, nil))

            case .success(let cart):
                let sku = selectedArticle.sku
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

    public func recommendations(forSKU sku: String, completion: @escaping RecommendationCompletion) {
        let endpoint = GetArticleRecommendationsEndpoint(config: config, sku: sku)
        fetch(from: endpoint, completion: completion)
    }

    public func addresses(completion: @escaping AddressesCompletion) {
        let endpoint = GetAddressesEndpoint(config: config)
        fetch(from: endpoint, completion: completion)
    }

    public func deleteAddress(withId addressId: String, completion: @escaping SuccessCompletion) {
        let endpoint = DeleteAddressEndpoint(config: config, addressId: addressId)
        touch(endpoint: endpoint, completion: completion)
    }

    public func createAddress(_ request: CreateAddressRequest, completion: @escaping AddressChangeCompletion) {
        let endpoint = CreateAddressEndpoint(config: config, createAddressRequest: request)
        fetch(from: endpoint, completion: completion)
    }

    public func updateAddress(withId addressId: String,
                              request: UpdateAddressRequest,
                              completion: @escaping AddressChangeCompletion) {
        let endpoint = UpdateAddressEndpoint(config: config, addressId: addressId, updateAddressRequest: request)
        fetch(from: endpoint, completion: completion)
    }

    public func checkAddress(_ request: CheckAddressRequest, completion: @escaping AddressCheckCompletion) {
        let endpoint = CheckAddressEndpoint(config: config, checkAddressRequest: request)
        fetch(from: endpoint, completion: completion)
    }

}

private extension AtlasAPIClient {

    func isCheckoutFailed(error: Error) -> Bool {
        if case let AtlasAPIError.backend(status, _, _, _) = error, status == HTTPStatus.conflict {
            return true
        } else {
            return false
        }
    }

}
