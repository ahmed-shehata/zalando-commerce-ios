//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

/**
 Completion block `AtlasResult` with the no content returned
 */
public typealias NoContentCompletion = AtlasResult<Bool> -> Void

/**
 Completion block `AtlasResult` with the `Customer` struct as a success value
 */
public typealias CustomerCompletion = AtlasResult<Customer> -> Void

/**
 Completion block `AtlasResult` with the `Cart` struct as a success value
 */
public typealias CartCompletion = AtlasResult<Cart> -> Void

/**
 Completion block `AtlasResult` with the `Checkout` struct as a success value
 */
public typealias CheckoutCompletion = AtlasResult<Checkout> -> Void

/**
 Completion block `AtlasResult` with the `Checkout` & `Cart` structs as a success value
 */
public typealias CheckoutCartCompletion = AtlasResult<(checkout: Checkout, cart: Cart)> -> Void

/**
 Completion block `AtlasResult` with the `Order` struct as a success value
 */
public typealias OrderCompletion = AtlasResult<Order> -> Void

/**
 Completion block `AtlasResult` with the `Article` struct as a success value
 */
public typealias ArticleCompletion = AtlasResult<Article> -> Void

/**
 Completion block `AtlasResult` with arry of the `UserAddress` struct as a success value
 */
public typealias AddressesCompletion = AtlasResult<[UserAddress]> -> Void

/**
 Completion block `AtlasResult` with the `UserAddress` struct as a success value
 */
public typealias AddressCreateUpdateCompletion = AtlasResult<UserAddress> -> Void

/**
 Completion block `AtlasResult` with the `CheckAddressResponse` struct as a success value
 */
public typealias CheckAddressCompletion = AtlasResult<CheckAddressResponse> -> Void

extension APIClient {

    public func customer(completion: CustomerCompletion) {
        let endpoint = GetCustomerEndpoint(serviceURL: config.checkoutURL)

        fetch(from: endpoint, completion: completion)
    }

    public func createCart(cartItemRequests: CartItemRequest..., completion: CartCompletion) {
        let parameters = CartRequest(salesChannel: config.salesChannel,
            items: cartItemRequests,
            replaceItems: true).toJSON()
        let endpoint = CreateCartEndpoint(serviceURL: config.checkoutURL, parameters: parameters)

        fetch(from: endpoint, completion: completion)
    }

    public func createCheckoutCart(for articleSKU: String, addresses: CheckoutAddresses? = nil, completion: CheckoutCartCompletion) {
        let cartItemRequest = CartItemRequest(sku: articleSKU, quantity: 1)

        createCart(cartItemRequest) { cartResult in
            switch cartResult {
            case .failure(let error):
                completion(.failure(error))

            case .success(let cart):
                let itemExists = cart.items.contains { $0.sku == articleSKU } && !cart.itemsOutOfStock.contains(articleSKU)
                guard itemExists else {
                    completion(.failure(AtlasCheckoutError.outOfStock))
                    return
                }

                self.createCheckout(cart.id, addresses: addresses) { checkoutResult in
                    switch checkoutResult {
                    case .failure(let error):
                        if self.errorBecauseCheckoutFailed(error) {
                            let checkoutError = AtlasAPIError.checkoutFailed(cart: cart, error: error)
                            completion(.failure(checkoutError))
                        } else {
                            completion(.failure(error))
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
        let endpoint = CreateCheckoutEndpoint(serviceURL: config.checkoutURL, parameters: parameters)

        fetch(from: endpoint, completion: completion)
    }

    public func updateCheckout(checkoutId: String, updateCheckoutRequest: UpdateCheckoutRequest, completion: CheckoutCompletion) {
        let endpoint = UpdateCheckoutEndpoint(serviceURL: config.checkoutURL,
            parameters: updateCheckoutRequest.toJSON(),
            checkoutId: checkoutId)

        fetch(from: endpoint, completion: completion)
    }

    public func createOrder(checkoutId: String, completion: OrderCompletion) {
        let parameters = OrderRequest(checkoutId: checkoutId).toJSON()
        let endpoint = CreateOrderEndpoint(serviceURL: config.checkoutURL,
            parameters: parameters,
            checkoutId: checkoutId)

        fetch(from: endpoint, completion: completion)
    }

    public func article(forSKU sku: String, completion: ArticleCompletion) {
        let endpoint = GetArticlesEndpoint(serviceURL: config.catalogURL,
            skus: [sku],
            salesChannel: config.salesChannel,
            clientId: config.clientId,
            fields: nil)

        let fetchCompletion: ArticleCompletion = { result in
            if case let .success(article) = result where !article.hasAvailableUnits {
                completion(.failure(AtlasCheckoutError.outOfStock))
            } else {
                completion(result)
            }
        }
        fetch(from: endpoint, completion: fetchCompletion)
    }

    public func addresses(completion: AddressesCompletion) {
        let endpoint = GetAddressesEndpoint(serviceURL: config.checkoutURL,
            salesChannel: config.salesChannel)

        fetch(from: endpoint, completion: completion)
    }

    public func deleteAddress(addressId: String, completion: NoContentCompletion) {
        let endpoint = DeleteAddressEndpoint(serviceURL: config.checkoutURL,
            addressId: addressId,
            salesChannel: config.salesChannel)
        touch(endpoint, completion: completion)
    }

    public func createAddress(request: CreateAddressRequest, completion: AddressCreateUpdateCompletion) {
        let endpoint = CreateAddressEndpoint(serviceURL: config.checkoutURL,
            createAddressRequest: request,
            salesChannel: config.salesChannel)
        fetch(from: endpoint, completion: completion)
    }

    public func updateAddress(addressId: String, request: UpdateAddressRequest, completion: AddressCreateUpdateCompletion) {
        let endpoint = UpdateAddressEndpoint(serviceURL: config.checkoutURL,
            addressId: addressId,
            updateAddressRequest: request,
            salesChannel: config.salesChannel)
        fetch(from: endpoint, completion: completion)
    }

    public func checkAddress(request: CheckAddressRequest, completion: CheckAddressCompletion) {
        let endpoint = CheckAddressEndpoint(serviceURL: config.checkoutURL,
            checkAddressRequest: request)
        fetch(from: endpoint, completion: completion)
    }

}

private extension APIClient {

    private func errorBecauseCheckoutFailed(error: ErrorType) -> Bool {
        if case let AtlasAPIError.backend(status, _, _, _) = error where status == 409 {
            return true
        } else {
            return false
        }
    }

}
