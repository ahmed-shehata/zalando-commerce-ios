//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct AtlasAPI {

    let client: APIClient

    public var config: Config {
        return client.config
    }

    init(config: Config, session: URLSession = .shared) {
        self.client = APIClient(config: config, session: session)
    }

    public func customer(completion: @escaping CustomerCompletion) {
        let endpoint = GetCustomerEndpoint(config: config)
        client.fetch(from: endpoint, completion: completion)
    }

    public func createCart(withItems cartItemRequests: [CartItemRequest], completion: @escaping CartCompletion) {
        let parameters = CartRequest(items: cartItemRequests, replaceItems: true).toJSON()
        let endpoint = CreateCartEndpoint(config: config, parameters: parameters)
        client.fetch(from: endpoint, completion: completion)
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

                self.createCheckout(from: cart.id, addresses: addresses) { checkoutResult in
                    switch checkoutResult {
                    case .failure(let error, _):
                        if case let AtlasAPIError.backend(status, _, _, _) = error, status == HTTPStatus.conflict {
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

    public func createCheckout(from cartId: CartId, addresses: CheckoutAddresses? = nil, completion: @escaping CheckoutCompletion) {
        let parameters = CreateCheckoutRequest(cartId: cartId, addresses: addresses).toJSON()
        let endpoint = CreateCheckoutEndpoint(config: config, parameters: parameters)
        client.fetch(from: endpoint, completion: completion)
    }

    public func updateCheckout(with checkoutId: CheckoutId,
                               updateCheckoutRequest: UpdateCheckoutRequest,
                               completion: @escaping CheckoutCompletion) {
        let endpoint = UpdateCheckoutEndpoint(config: config, parameters: updateCheckoutRequest.toJSON(), checkoutId: checkoutId)
        client.fetch(from: endpoint, completion: completion)
    }

    public func createOrder(from checkoutId: CheckoutId, completion: @escaping OrderCompletion) {
        let parameters = OrderRequest(checkoutId: checkoutId).toJSON()
        let endpoint = CreateOrderEndpoint(config: config, parameters: parameters, checkoutId: checkoutId)
        client.fetch(from: endpoint, completion: completion)
    }

    public func createGuestOrder(request: GuestOrderRequest, completion: @escaping GuestOrderCompletion) {
        let endpoint = CompleteGuestOrderEndpoint(config: config, parameters: request.toJSON())
        client.fetch(from: endpoint, completion: completion)
    }

    public func guestCheckoutPaymentSelectionURL(request: GuestPaymentSelectionRequest, completion: @escaping URLCompletion) {
        let endpoint = CreateGuestOrderEndpoint(config: config, parameters: request.toJSON())
        client.fetchRedirectLocation(endpoint: endpoint, completion: completion)
    }

    public func guestCheckout(with checkoutId: CheckoutId, token: CheckoutToken, completion: @escaping GuestCheckoutCompletion) {
        let endpoint = GetGuestCheckoutEndpoint(config: config, checkoutId: checkoutId, token: token)
        client.fetch(from: endpoint, completion: completion)
    }

    public func article(with sku: ConfigSKU, completion: @escaping ArticleCompletion) {
        let endpoint = GetArticleEndpoint(config: config, sku: sku)

        let fetchCompletion: ArticleCompletion = { result in
            if case let .success(article) = result, !article.hasAvailableUnits {
                completion(.failure(AtlasCheckoutError.outOfStock, nil))
            } else {
                completion(result)
            }
        }
        client.fetch(from: endpoint, completion: fetchCompletion)
    }

    public func addresses(completion: @escaping AddressesCompletion) {
        let endpoint = GetAddressesEndpoint(config: config)
        client.fetch(from: endpoint, completion: completion)
    }

    public func deleteAddress(with addressId: AddressId, completion: @escaping SuccessCompletion) {
        let endpoint = DeleteAddressEndpoint(config: config, addressId: addressId)
        client.touch(endpoint: endpoint, completion: completion)
    }

    public func createAddress(_ request: CreateAddressRequest, completion: @escaping AddressChangeCompletion) {
        let endpoint = CreateAddressEndpoint(config: config, createAddressRequest: request)
        client.fetch(from: endpoint, completion: completion)
    }

    public func updateAddress(with addressId: AddressId,
                              request: UpdateAddressRequest,
                              completion: @escaping AddressChangeCompletion) {
        let endpoint = UpdateAddressEndpoint(config: config, addressId: addressId, updateAddressRequest: request)
        client.fetch(from: endpoint, completion: completion)
    }

    public func checkAddress(_ request: CheckAddressRequest, completion: @escaping AddressCheckCompletion) {
        let endpoint = CheckAddressEndpoint(config: config, checkAddressRequest: request)
        client.fetch(from: endpoint, completion: completion)
    }

}

