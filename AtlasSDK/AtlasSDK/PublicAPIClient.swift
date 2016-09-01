//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public typealias ArticlesCompletion = AtlasResult<Article> -> Void
public typealias AddressesCompletion = AtlasResult<AddressList> -> Void

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

extension APIClient {

    public func customer(completion: CustomerCompletion) {
        fetch(customer(), completion: completion)
    }

    public func createCart(cartItemRequests: CartItemRequest..., completion: CartCompletion) {
        let cartRequest = CartRequest(salesChannel: self.config.salesChannel, items: cartItemRequests, replaceItems: true)
        let parameters = cartRequest.toJSON()

        fetch(createCart(parameters: parameters), completion: completion)
    }

    public func createCheckout(withArticle article: Article, selectedUnitIndex: Int, completion: CheckoutCompletion) {
        let articleSKU = article.units[selectedUnitIndex].id
        let cartItemRequest = CartItemRequest(sku: articleSKU, quantity: 1)

        createCart(cartItemRequest) { cartResult in
            switch cartResult {
            case .failure(let error):
                completion(.failure(error))

            case .success(let cart):
                self.fetchAddressList { addressListResult in
                    switch addressListResult {
                    case .failure(let error):
                        completion(.failure(error))

                    case .success(let addressList):
                        self.createCheckout(cart.id) { checkoutResult in
                            switch checkoutResult {
                            case .failure(let error):
                                let checkoutError = AtlasAPIError.checkoutFailed(addresses: addressList, cartId: cart.id, error: error)
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
        shippingAddressId: String? = nil, checkoutCompletion: AtlasResult<Checkout> -> Void) {
            let checkoutRequest = CreateCheckoutRequest(cartId: cartId,
                billingAddressId: billingAddressId,
                shippingAddressId: shippingAddressId)
            let parameters = checkoutRequest.toJSON()
            fetch(createCheckout(parameters: parameters), completion: checkoutCompletion)
    }

    public func updateCheckout(checkoutId: String, updateCheckoutRequest: UpdateCheckoutRequest, completion: CheckoutCompletion) {
        fetch(updateCheckout(checkoutId, parameters: updateCheckoutRequest.toJSON()), completion: completion)
    }

    public func createOrder(checkoutId: String, orderCompletion: OrderCompletion) {
        let checkoutRequest = OrderRequest(checkoutId: checkoutId)
        let parameters = checkoutRequest.toJSON()
        fetch(createOrder(parameters: parameters), completion: orderCompletion)
    }

    public func article(forSKU sku: String, completion: ArticlesCompletion) {
        fetch(articles(forSKUs: sku), completion: completion)
    }

    public func fetchAddressList(completion: AddressesCompletion) {
        fetch(makeFetchAddressListEndpoint(config.salesChannel), completion: completion)
    }

}
