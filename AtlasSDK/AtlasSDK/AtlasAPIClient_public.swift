//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

/**
 Completion block `AtlasAPIResult` with the no content returned
 */
public typealias NoContentCompletion = AtlasAPIResult<Bool> -> Void

/**
 Completion block `AtlasAPIResult` with the `Customer` struct as a success value
 */
public typealias CustomerCompletion = AtlasAPIResult<Customer> -> Void

/**
 Completion block `AtlasAPIResult` with the `Cart` struct as a success value
 */
public typealias CartCompletion = AtlasAPIResult<Cart> -> Void

/**
 Completion block `AtlasAPIResult` with the `Checkout` struct as a success value
 */
public typealias CheckoutCompletion = AtlasAPIResult<Checkout> -> Void

/**
 Completion block `AtlasAPIResult` with the `Checkout` & `Cart` structs as a success value
 */
public typealias CheckoutCartCompletion = AtlasAPIResult<(checkout: Checkout, cart: Cart)> -> Void

/**
 Completion block `AtlasAPIResult` with the `Order` struct as a success value
 */
public typealias OrderCompletion = AtlasAPIResult<Order> -> Void

/**
 Completion block `AtlasAPIResult` with the `Article` struct as a success value
 */
public typealias ArticleCompletion = AtlasAPIResult<Article> -> Void

/**
 Completion block `AtlasAPIResult` with array of the `UserAddress` struct as a success value
 */
public typealias AddressesCompletion = AtlasAPIResult<[UserAddress]> -> Void

/**
 Completion block `AtlasAPIResult` with the `UserAddress` struct as a success value
 */
public typealias AddressCreateUpdateCompletion = AtlasAPIResult<UserAddress> -> Void

/**
 Completion block `AtlasAPIResult` with the `CheckAddressResponse` struct as a success value
 */
public typealias CheckAddressCompletion = AtlasAPIResult<CheckAddressResponse> -> Void

extension AtlasAPIClient {

    public func customer(completion: CustomerCompletion) {
        let endpoint = GetCustomerEndpoint(serviceURL: config.checkoutURL,
                                           salesChannel: config.salesChannel.identifier)
        fetch(from: endpoint, completion: completion)
    }

    public func createCart(cartItemRequests: [CartItemRequest], completion: CartCompletion) {
        let parameters = CartRequest(items: cartItemRequests, replaceItems: true).toJSON()
        let endpoint = CreateCartEndpoint(serviceURL: config.checkoutURL,
                                          parameters: parameters,
                                          salesChannel: config.salesChannel.identifier)
        fetch(from: endpoint, completion: completion)
    }

    public func createCheckoutCart(sku: String, addresses: CheckoutAddresses? = nil, completion: CheckoutCartCompletion) {
        let cartItemRequest = CartItemRequest(sku: sku, quantity: 1)

        createCart([cartItemRequest]) { cartResult in
            switch cartResult {
            case .failure(let error, _):
                completion(.failure(error, nil))

            case .success(let cart):
                let itemExists = cart.items.contains { $0.sku == sku } && !cart.itemsOutOfStock.contains(sku)
                guard itemExists else {
                    completion(.failure(AtlasCheckoutError.outOfStock, nil))
                    return
                }

                self.createCheckout(cart.id, addresses: addresses) { checkoutResult in
                    switch checkoutResult {
                    case .failure(let error, _):
                        if self.errorBecauseCheckoutFailed(error) {
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

    public func createCheckout(cartId: String, addresses: CheckoutAddresses? = nil, completion: CheckoutCompletion) {
        let parameters = CreateCheckoutRequest(cartId: cartId, addresses: addresses).toJSON()
        let endpoint = CreateCheckoutEndpoint(serviceURL: config.checkoutURL,
                                              parameters: parameters,
                                              salesChannel: config.salesChannel.identifier)
        fetch(from: endpoint, completion: completion)
    }

    public func updateCheckout(checkoutId: String, updateCheckoutRequest: UpdateCheckoutRequest, completion: CheckoutCompletion) {
        let endpoint = UpdateCheckoutEndpoint(serviceURL: config.checkoutURL,
                                              parameters: updateCheckoutRequest.toJSON(),
                                              salesChannel: config.salesChannel.identifier,
                                              checkoutId: checkoutId)
        fetch(from: endpoint, completion: completion)
    }

    public func createOrder(checkoutId: String, completion: OrderCompletion) {
        let parameters = OrderRequest(checkoutId: checkoutId).toJSON()
        let endpoint = CreateOrderEndpoint(serviceURL: config.checkoutURL,
                                           parameters: parameters,
                                           salesChannel: config.salesChannel.identifier,
                                           checkoutId: checkoutId)
        fetch(from: endpoint, completion: completion)
    }

    public func article(sku: String, completion: ArticleCompletion) {
        let endpoint = GetArticleEndpoint(serviceURL: config.catalogURL,
                                          sku: sku,
                                          salesChannel: config.salesChannel.identifier,
                                          clientId: config.clientId,
                                          fields: nil)

        let fetchCompletion: ArticleCompletion = { result in
            if case let .success(article) = result where !article.hasAvailableUnits {
                completion(.failure(AtlasCheckoutError.outOfStock, nil))
            } else {
                completion(result)
            }
        }
        fetch(from: endpoint, completion: fetchCompletion)
    }

    public func addresses(completion: AddressesCompletion) {
        let endpoint = GetAddressesEndpoint(serviceURL: config.checkoutURL,
                                            salesChannel: config.salesChannel.identifier)
        fetch(from: endpoint, completion: completion)
    }

    public func deleteAddress(addressId: String, completion: NoContentCompletion) {
        let endpoint = DeleteAddressEndpoint(serviceURL: config.checkoutURL,
                                             addressId: addressId,
                                             salesChannel: config.salesChannel.identifier)
        touch(endpoint, completion: completion)
    }

    public func createAddress(request: CreateAddressRequest, completion: AddressCreateUpdateCompletion) {
        let endpoint = CreateAddressEndpoint(serviceURL: config.checkoutURL,
                                             createAddressRequest: request,
                                             salesChannel: config.salesChannel.identifier)
        fetch(from: endpoint, completion: completion)
    }

    public func updateAddress(addressId: String, request: UpdateAddressRequest, completion: AddressCreateUpdateCompletion) {
        let endpoint = UpdateAddressEndpoint(serviceURL: config.checkoutURL,
                                             addressId: addressId,
                                             updateAddressRequest: request,
                                             salesChannel: config.salesChannel.identifier)
        fetch(from: endpoint, completion: completion)
    }

    public func checkAddress(request: CheckAddressRequest, completion: CheckAddressCompletion) {
        let endpoint = CheckAddressEndpoint(serviceURL: config.checkoutURL,
                                            checkAddressRequest: request,
                                            salesChannel: config.salesChannel.identifier)
        fetch(from: endpoint, completion: completion)
    }

}

private extension AtlasAPIClient {

    private func errorBecauseCheckoutFailed(error: ErrorType) -> Bool {
        if case let AtlasAPIError.backend(status, _, _, _) = error where status == 409 {
            return true
        } else {
            return false
        }
    }

}
