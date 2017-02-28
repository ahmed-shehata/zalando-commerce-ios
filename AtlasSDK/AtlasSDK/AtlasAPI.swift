//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

/// Provides all functional API calls with their business logic.
///
/// - Note: If not specified otherwise – all API calls require user to be
///   logged in and accepted a consent. Otherwise `Result.failure` with
///   `APIError.unauthorized` is returned. 
public struct AtlasAPI {

    /// Configuration of a client handling API calls
    public var config: Config {
        return client.config
    }

    let client: APIClient

    init(config: Config, session: URLSession = .shared) {
        self.client = APIClient(config: config, session: session)
    }

}

// TODO: document it, please...

extension AtlasAPI {

    /// Retrieves current logged user as `Customer`.
    ///
    /// - Parameter completion: `Result.success` with logged user as `Customer` is passed
    public func customer(completion: @escaping APIResultCompletion<Customer>) {
        let endpoint = GetCustomerEndpoint(config: config)
        client.fetch(from: endpoint, completion: completion)
    }

    /// Creates `Cart` with given `CartItemRequest` items.
    ///
    /// - Parameters:
    ///   - cartItemRequests: list articles SKUs with quantities to be added to cart
    ///   - completion: `Result.success` with create `Cart` model.
    public func createCart(withItems cartItemRequests: [CartItemRequest],
                           completion: @escaping APIResultCompletion<Cart>) {
        let parameters = CartRequest(items: cartItemRequests, replaceItems: true).toJSON()
        let endpoint = CreateCartEndpoint(config: config, parameters: parameters)
        client.fetch(from: endpoint, completion: completion)
    }

    public func createCheckoutCart(for selectedArticle: SelectedArticle,
                                   addresses: CheckoutAddresses? = nil,
                                   completion: @escaping APIResultCompletion<CartCheckout>) {
        let cartItemRequest = CartItemRequest(sku: selectedArticle.sku, quantity: selectedArticle.quantity)

        createCart(withItems: [cartItemRequest]) { cartResult in
            switch cartResult {
            case .failure(let error, _):
                completion(.failure(error, nil))

            case .success(let cart):
                guard cart.hasStock(of: selectedArticle.sku) else {
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

    public func createCheckout(from cartId: CartId,
                               addresses: CheckoutAddresses? = nil,
                               completion: @escaping APIResultCompletion<Checkout>) {
        let parameters = CreateCheckoutRequest(cartId: cartId, addresses: addresses).toJSON()
        let endpoint = CreateCheckoutEndpoint(config: config, parameters: parameters)
        client.fetch(from: endpoint, completion: completion)
    }

    public func updateCheckout(with checkoutId: CheckoutId,
                               updateCheckoutRequest: UpdateCheckoutRequest,
                               completion: @escaping APIResultCompletion<Checkout>) {
        let endpoint = UpdateCheckoutEndpoint(config: config, parameters: updateCheckoutRequest.toJSON(), checkoutId: checkoutId)
        client.fetch(from: endpoint, completion: completion)
    }

    public func createOrder(from checkoutId: CheckoutId,
                            completion: @escaping APIResultCompletion<Order>) {
        let parameters = OrderRequest(checkoutId: checkoutId).toJSON()
        let endpoint = CreateOrderEndpoint(config: config, parameters: parameters, checkoutId: checkoutId)
        client.fetch(from: endpoint, completion: completion)
    }

    public func createGuestOrder(request: GuestOrderRequest,
                                 completion: @escaping APIResultCompletion<GuestOrder>) {
        let endpoint = CompleteGuestOrderEndpoint(config: config, parameters: request.toJSON())
        client.fetch(from: endpoint, completion: completion)
    }

    public func guestCheckoutPaymentSelectionURL(request: GuestPaymentSelectionRequest,
                                                 completion: @escaping APIResultCompletion<URL>) {
        let endpoint = CreateGuestOrderEndpoint(config: config, parameters: request.toJSON())
        client.fetchRedirection(endpoint: endpoint, completion: completion)
    }

    public func guestCheckout(with checkoutId: CheckoutId,
                              token: CheckoutToken,
                              completion: @escaping APIResultCompletion<GuestCheckout>) {
        let endpoint = GetGuestCheckoutEndpoint(config: config, checkoutId: checkoutId, token: token)
        client.fetch(from: endpoint, completion: completion)
    }

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

    public func addresses(completion: @escaping APIResultCompletion<[UserAddress]>) {
        let endpoint = GetAddressesEndpoint(config: config)
        client.fetch(from: endpoint, completion: completion)
    }

    public func deleteAddress(with addressId: AddressId,
                              completion: @escaping APIResultCompletion<Bool>) {
        let endpoint = DeleteAddressEndpoint(config: config, addressId: addressId)
        client.touch(endpoint: endpoint, completion: completion)
    }

    public func createAddress(_ request: CreateAddressRequest,
                              completion: @escaping APIResultCompletion<UserAddress>) {
        let endpoint = CreateAddressEndpoint(config: config, createAddressRequest: request)
        client.fetch(from: endpoint, completion: completion)
    }

    public func updateAddress(with addressId: AddressId,
                              request: UpdateAddressRequest,
                              completion: @escaping APIResultCompletion<UserAddress>) {
        let endpoint = UpdateAddressEndpoint(config: config, addressId: addressId, updateAddressRequest: request)
        client.fetch(from: endpoint, completion: completion)
    }

    public func checkAddress(_ request: CheckAddressRequest,
                             completion: @escaping APIResultCompletion<CheckAddressResponse>) {
        let endpoint = CheckAddressEndpoint(config: config, checkAddressRequest: request)
        client.fetch(from: endpoint, completion: completion)
    }

}

extension AtlasAPI {

    /// Determines if a client is authorized with access token to call restricted endpoints.
    public var isAuthorized: Bool {
        return config.authorizationToken != nil
    }

    /// Authorizes a client with given access token required in restricted endpoints.
    ///
    /// - Note: Stores `token` securely and makes it globally available for all calls
    ///   to restricted endpoints identified by same `Options.environment`
    ///
    /// - Postcondition:
    ///   - If a client is authorized successfully `NSNotification.Name.AtlasAuthorized`
    ///     is posted on `NotificationCenter.default`, otherwise it is `NSNotification.Name.AtlasDeauthorized`.
    ///   - `NSNotification.Name.AtlasAuthorizationChanged` is always posted regadless the result.
    ///
    /// - Parameter with: access token passed to all restricted endpoint calls
    ///
    /// - Returns: `true` if token was correctly stored and client is authorized, otherwise `false`
    @discardableResult
    public func authorize(with token: AuthorizationToken) -> Bool {
        let token = APIAccessToken.store(token: token, for: config)
        let isAuthorized = token != nil
        notify(isAuthorized: isAuthorized, withToken: token)
        return isAuthorized
    }

    /// Deauthorizes a client from accessing restricted endpoints.
    public func deauthorize() {
        let token = APIAccessToken.delete(for: config)
        notify(isAuthorized: false, withToken: token)
    }

    /// Deauthorizes all clients by removing all stored tokens.
    public static func deauthorizeAll() {
        APIAccessToken.wipe().forEach { token in
            notify(api: nil, isAuthorized: false, withToken: token)
        }
    }

}
