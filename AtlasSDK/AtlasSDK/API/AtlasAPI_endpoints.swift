//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

// TODO: document it, please...

extension AtlasAPI {

    /**
     Fetches `Article` with given SKU.
    
     - Parameters:
       - sku: SKU of an article to fetch
       - completion: completes async with `APIResult.success` with `Article`
     */
    public func article(with sku: ConfigSKU,
                        completion: @escaping APIResultCompletion<Article>) {
        let endpoint = GetArticleEndpoint(config: config, sku: sku)

        let fetchCompletion: APIResultCompletion<Article> = { result in
            if case let .success(article) = result, !article.hasAvailableUnits {
                completion(.failure(CheckoutError.outOfStock, nil))
            } else {
                completion(result)
            }
        }
        client.fetch(from: endpoint, completion: fetchCompletion)
    }

    /**
     Fetches current logged user as `Customer`.

     - Parameter completion: completes async with `APIResult.success` with logged user as `Customer`
     */
    public func customer(completion: @escaping APIResultCompletion<Customer>) {
        let endpoint = GetCustomerEndpoint(config: config)
        client.fetch(from: endpoint, completion: completion)
    }

    /**
     Creates `Cart` with given `CartItemRequest` items.

     - Parameters:
         - cartItemRequests: list articles SKUs with quantities to be added to cart
         - completion: completes async with `APIResult.success` with `Cart` model created.
     */
    public func createCart(with cartItemRequests: [CartItemRequest],
                           completion: @escaping APIResultCompletion<Cart>) {
        let parameters = CartRequest(items: cartItemRequests, replaceItems: true).toJSON()
        let endpoint = CreateCartEndpoint(config: config, parameters: parameters)
        client.fetch(from: endpoint, completion: completion)
    }

    /**
     Creates `Cart`, and makes `Checkout` from it. Additionally handle specific corner cases.
     
     Handled cases:
        - when article has no stock available `completion` returns `Result.failure` with `CheckoutError.outOfStock`
        - when checkout creation fails `completion` returns `Result.failure` with `APIError.checkoutFailed` and created `Cart`

     - Parameters:
         - cartItemRequest: article SKU and quantity to be added to the cart
         - addresses: addresses to be passed to the checkout
         - completion: completes async with `APIResult.success` with `CartCheckout`.
     */
    public func createCartCheckout(with cartItemRequest: CartItemRequest,
                                   addresses: CheckoutAddresses? = nil,
                                   completion: @escaping APIResultCompletion<CartCheckout>) {
        createCart(with: [cartItemRequest]) { cartResult in
            switch cartResult {
            case .failure(let error, _):
                completion(.failure(error, nil))

            case .success(let cart):
                guard cart.hasStock(of: cartItemRequest.sku) else {
                    return completion(.failure(CheckoutError.outOfStock, nil))
                }

                self.createCheckout(from: cart.id, addresses: addresses) { checkoutResult in
                    switch checkoutResult {
                    case .failure(let error, _):
                        if case let APIError.backend(status, _, _, _) = error, status == HTTPStatus.conflict {
                            let checkoutError = APIError.checkoutFailed(cart: cart, error: error)
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

    /**
     Creates `Checkout` based on `CartId`.

     - Parameters:
       - cartId: identifier of a cart (`Cart.id`)
       - addresses: set of billing and shipping addresses
       - completion: completes async with `APIResult.success` with `Checkout`.
     */
    public func createCheckout(from cartId: CartId,
                               addresses: CheckoutAddresses? = nil,
                               completion: @escaping APIResultCompletion<Checkout>) {
        let parameters = CreateCheckoutRequest(cartId: cartId, addresses: addresses).toJSON()
        let endpoint = CreateCheckoutEndpoint(config: config, parameters: parameters)
        client.fetch(from: endpoint, completion: completion)
    }

    /**
     Updates `Checkout` shipping and/or billing addresses.

     - Parameters:
       - checkoutId: identifier of a checkout (`Checkout.id`)
       - updateCheckoutRequest: new shipping and/or billing address
       - completion: completes async with `APIResult.success` with `Checkout`.
     */
    public func updateCheckout(with checkoutId: CheckoutId,
                               updateCheckoutRequest: UpdateCheckoutRequest,
                               completion: @escaping APIResultCompletion<Checkout>) {
        let endpoint = UpdateCheckoutEndpoint(config: config, parameters: updateCheckoutRequest.toJSON(), checkoutId: checkoutId)
        client.fetch(from: endpoint, completion: completion)
    }

    /**
     Places order based on formerly created checkout.

     - Parameters:
       - checkoutId: identifier of a checkout (`Checkout.id`)
       - completion: completes async with `APIResult.success` with `Order`.
     */
    public func createOrder(from checkout: Checkout,
                            completion: @escaping APIResultCompletion<Order>) {
        let parameters = OrderRequest(checkout: checkout).toJSON()
        let endpoint = CreateOrderEndpoint(config: config, parameters: parameters)
        client.fetch(from: endpoint, completion: completion)
    }

    /**
     Retrieves details of `GuestCheckout`.

     - Parameters:
         - checkoutId: identifier of a guest checkout (`GuestCheckout.id`)
         - completion: completes async with `APIResult.success` with `GuestCheckout`.
     */
    public func guestCheckout(with guestCheckoutId: GuestCheckoutId,
                              completion: @escaping APIResultCompletion<GuestCheckout>) {
        let endpoint = GetGuestCheckoutEndpoint(config: config, guestCheckoutId: guestCheckoutId)
        client.fetch(from: endpoint, completion: completion)
    }

    /**
     Retrieves `URL` containing web page handling payment process.
     
     - Note: The result `URL` should be passed to a web view, and the response returned
       should be parsed using `PaymentStatus`.

     - Parameters:
       - request: request containing all the data needed by Guest Checkout
       - completion: completes async with `APIResult.success` with `URL`.
     */
    public func guestCheckoutPaymentSelectionURL(request: GuestPaymentSelectionRequest,
                                                 completion: @escaping APIResultCompletion<URL>) {
        let endpoint = CreateGuestOrderEndpoint(config: config, parameters: request.toJSON())
        client.fetchRedirection(endpoint: endpoint, completion: completion)
    }

    /**
     Creates order from a checkout in Guest Checkout mode.

     - Parameters:
         - request: guest checkout with token
         - completion: completes async with `APIResult.success` with `GuestOrder`.
     */
    public func createGuestOrder(request: GuestOrderRequest,
                                 completion: @escaping APIResultCompletion<GuestOrder>) {
        let endpoint = CompleteGuestOrderEndpoint(config: config, parameters: request.toJSON())
        client.fetch(from: endpoint, completion: completion)
    }

    /**
     Fetches list of `UserAddress` containing all customer's addresses available for both
     shipping and billing.
    
     - Parameter completion: completes async with `APIResult.success` with `[UserAddress]`
     */
    public func addresses(completion: @escaping APIResultCompletion<[UserAddress]>) {
        let endpoint = GetAddressesEndpoint(config: config)
        client.fetch(from: endpoint, completion: completion)
    }

    /**
     Creates new address in customer's address book.
    
     - Parameters:
       - request: address details request
       - completion: completes async with `APIResult.success` with created `UserAddress`.
     */
    public func createAddress(with request: CreateAddressRequest,
                              completion: @escaping APIResultCompletion<UserAddress>) {
        let endpoint = CreateAddressEndpoint(config: config, createAddressRequest: request)
        client.fetch(from: endpoint, completion: completion)
    }

    /**
     Updates customer's address.
    
     - Parameters:
       - request: address details to be updated
       - completion: completes async with `APIResult.success` with updated `UserAddress`.
     */
    public func updateAddress(with request: UpdateAddressRequest,
                              completion: @escaping APIResultCompletion<UserAddress>) {
        let endpoint = UpdateAddressEndpoint(config: config, updateAddressRequest: request)
        client.fetch(from: endpoint, completion: completion)
    }

    /**
     Deletes given `EquatableAddress` from customer's address book.
     
     - Parameters:
         - address: `EquatableAddress` to be removed.
         - completion: completion: completes async with `APIResult.success` with success status.
     */
    public func delete(_ address: EquatableAddress,
                       completion: @escaping APIResultCompletion<Bool>) {
        let endpoint = DeleteAddressEndpoint(config: config, addressId: address.id)
        client.touch(endpoint: endpoint, completion: completion)
    }

    public func checkAddress(with request: CheckAddressRequest,
                             completion: @escaping APIResultCompletion<CheckAddressResponse>) {
        let endpoint = CheckAddressEndpoint(config: config, checkAddressRequest: request)
        client.fetch(from: endpoint, completion: completion)
    }

    public func recommendations(for sku: ConfigSKU,
                                completion: @escaping APIResultCompletion<[Recommendation]>) {
        let endpoint = GetArticleRecommendationsEndpoint(config: config, sku: sku)
        client.fetch(from: endpoint, completion: completion)
    }

}
