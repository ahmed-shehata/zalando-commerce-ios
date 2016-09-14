//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public typealias ArticlesCompletion = AtlasResult<Article> -> Void
public typealias AddressesCompletion = AtlasResult<[UserAddress]> -> Void

/**
 Completion block `AtlasResult` with the `Customer` struct as a success value
 */
public typealias CustomerCompletion = AtlasResult<Customer> -> Void

/**
 Completion block `AtlasResult` with the `Article` struct as a success value
 */
public typealias ArticleCompletion = AtlasResult<Article> -> Void

/**
 Completion block `AtlasResult` with the `Cart` struct as a success value
 */
public typealias CartCompletion = AtlasResult<Cart> -> Void

/**
 Completion block `AtlasResult` with the `Checkout` struct as a success value
 */
public typealias CheckoutCompletion = AtlasResult<Checkout> -> Void

/**
 Completion block `AtlasResult` with the `Order` struct as a success value
 */
public typealias OrderCompletion = AtlasResult<Order> -> Void

@available( *, deprecated, message = "Should be deleted")
public typealias EmptyCompletion = AtlasResult<EmptyResponse> -> Void

extension APIClient {

    public func customer(completion: CustomerCompletion) {
        let endpoint = GetCustomerEndpoint(serviceURL: config.checkoutAPIURL)

        fetch(from: endpoint, completion: completion)
    }

    public func createCart(cartItemRequests: CartItemRequest..., completion: CartCompletion) {
        let parameters = CartRequest(salesChannel: config.salesChannel,
            items: cartItemRequests,
            replaceItems: true).toJSON()
        let endpoint = CreateCartEndpoint(serviceURL: config.checkoutAPIURL, parameters: parameters)

        fetch(from: endpoint, completion: completion)
    }

    public func createCheckout(withSelectedArticleUnit selectedArticleUnit: SelectedArticleUnit,
        billingAddressId: String? = nil, shippingAddressId: String? = nil, completion: CheckoutCompletion) {
            let articleSKU = selectedArticleUnit.article.units[selectedArticleUnit.selectedUnitIndex].id
            let cartItemRequest = CartItemRequest(sku: articleSKU, quantity: 1)

            createCart(cartItemRequest) { cartResult in
                switch cartResult {
                case .failure(let error):
                    completion(.failure(error))

                case .success(let cart):
                    self.addresses { addressListResult in
                        switch addressListResult {
                        case .failure(let error):
                            completion(.failure(error))

                        case .success(let addressList):
                            self.createCheckout(cart.id, billingAddressId: billingAddressId,
                                shippingAddressId: shippingAddressId) { checkoutResult in
                                    switch checkoutResult {
                                    case .failure(let error):
                                        let checkoutError = AtlasAPIError.checkoutFailed(addresses: addressList,
                                            cartId: cart.id, error: error)
                                        completion(.failure(checkoutError))
                                    case .success(let checkout):
                                        completion(.success(checkout))
                                    }
                            }
                        }
                    }
                }
            }
    }

    public func createCheckout(cartId: String, billingAddressId: String? = nil,
        shippingAddressId: String? = nil, completion: CheckoutCompletion) {
            let parameters = CreateCheckoutRequest(cartId: cartId,
                billingAddressId: billingAddressId,
                shippingAddressId: shippingAddressId).toJSON()
            let endpoint = CreateCheckoutEndpoint(serviceURL: config.checkoutAPIURL, parameters: parameters)

            fetch(from: endpoint, completion: completion)
    }

    public func updateCheckout(checkoutId: String, updateCheckoutRequest: UpdateCheckoutRequest, completion: CheckoutCompletion) {
        let endpoint = UpdateCheckoutEndpoint(serviceURL: config.checkoutAPIURL,
            parameters: updateCheckoutRequest.toJSON(),
            checkoutId: checkoutId)

        fetch(from: endpoint, completion: completion)
    }

    public func createOrder(checkoutId: String, completion: OrderCompletion) {
        let parameters = OrderRequest(checkoutId: checkoutId).toJSON()
        let endpoint = CreateOrderEndpoint(serviceURL: config.checkoutAPIURL,
            parameters: parameters,
            checkoutId: checkoutId)

        fetch(from: endpoint, completion: completion)
    }

    public func article(forSKU sku: String, completion: ArticlesCompletion) {
        let endpoint = GetArticlesEndpoint(serviceURL: config.catalogAPIURL,
            skus: [sku],
            salesChannel: config.salesChannel,
            clientId: config.clientId,
            fields: nil)

        fetch(from: endpoint, completion: completion)
    }

    public func addresses(completion: AddressesCompletion) {
        let endpoint = GetAddressesEndpoint(serviceURL: config.checkoutAPIURL,
            salesChannel: config.salesChannel)

        fetch(from: endpoint, completion: completion)
    }

    public func deleteAddress(addressId: String, completion: EmptyCompletion) {
        let endpoint = DeleteAddressEndpoint(serviceURL: config.checkoutAPIURL,
            addressId: addressId,
            salesChannel: config.salesChannel)
        fetch(from: endpoint, completion: completion)
    }

}
