//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public typealias ArticlesCompletion = AtlasResult<Article> -> Void
public typealias AddressesCompletion = AtlasResult<AddressList> -> Void

struct APIClient {

    let config: Config

    var urlSession: NSURLSession = NSURLSession.sharedSession()

    private var requestBuilders = [APIRequestBuilder]()

    init(config: Config) {
        self.config = config
    }

    mutating func customer(completion: CustomerCompletion) {
        fetch(customer(), completion: completion)
    }

    mutating func createCart(cartItemRequests: [CartItemRequest], completion: CartCompletion) {
        let cartRequest = CartRequest(salesChannel: self.config.salesChannel, items: cartItemRequests, replaceItems: true)
        let parameters = cartRequest.toJSON()

        fetch(createCart(parameters: parameters), completion: completion)
    }

    mutating func createCheckout(cartId: String, billingAddressId: String? = nil,
        shippingAddressId: String? = nil, checkoutCompletion: CheckoutCompletion) {
            let checkoutRequest = CheckoutRequest(cartId: cartId, billingAddressId: billingAddressId, shippingAddressId: shippingAddressId)
            let parameters = checkoutRequest.toJSON()
            fetch(createCheckout(parameters: parameters), completion: checkoutCompletion)
    }

    mutating func createOrder(checkoutId: String, orderCompletion: OrderCompletion) {
        let checkoutRequest = OrderRequest(checkoutId: checkoutId)
        let parameters = checkoutRequest.toJSON()
        fetch(createOrder(parameters: parameters), completion: orderCompletion)
    }

    mutating func article(forSKU sku: String, completion: ArticlesCompletion) {
        fetch(articles(forSKUs: sku), completion: completion)
    }

    mutating func fetchAddressList(completion: AddressesCompletion) {
        fetch(makeFetchAddressListEndpoint(config.salesChannel), completion: completion)
    }

    private mutating func fetch<Model: JSONInitializable>(endpoint: EndpointType, completion: AtlasResult<Model> -> Void) {
        builder(forEndpoint: endpoint).execute { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                if let model = Model(json: response.body) {
                    completion(.success(model))
                } else {
                    completion(.failure(Error.invalidResponseFormat))
                }
            }
        }
    }

    private mutating func builder(forEndpoint endpoint: EndpointType) -> RequestBuilder {
        let builder = APIRequestBuilder(loginURL: self.config.loginURL, endpoint: endpoint)
        builder.executionFinished = {
            self.requestBuilders.remove($0)
        }
        requestBuilders.append(builder)
        return builder
    }

}
