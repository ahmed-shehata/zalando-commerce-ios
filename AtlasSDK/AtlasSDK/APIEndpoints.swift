//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension APIClient {

    func articles(forSKUs skus: String..., fields: [String]? = nil) -> EndpointType {
        let path = "articles/\(skus.joinWithSeparator(",") ?? "")"
        let queryItems = NSURLQueryItem.build(
            ["sales_channel": self.config.salesChannel,
                "client_id": self.config.clientId,
                "fields": fields?.joinWithSeparator(",")])
        return APIEndpoint(baseURL: self.config.catalogAPIURL,
            acceptedContentType: "application/x.zalando.article+json",
            path: path,
            queryItems: queryItems)
    }

    func customer() -> EndpointType {
        return APIEndpoint(baseURL: self.config.checkoutAPIURL,
            acceptedContentType: "application/x.zalando.customer+json",
            path: "customer")
    }

    func createCart(parameters parameters: [String: AnyObject]) -> EndpointType {
        return APIEndpoint(baseURL: self.config.checkoutAPIURL,
            method: .POST,
            contentType: "application/x.zalando.cart.create+json",
            acceptedContentType: "application/x.zalando.cart.create.response+json",
            path: "carts",
            parameters: parameters)
    }

    func createCheckout(parameters parameters: [String: AnyObject]) -> EndpointType {
        return APIEndpoint(baseURL: self.config.checkoutAPIURL,
            method: .POST,
            contentType: "application/x.zalando.customer.checkout.create+json",
            acceptedContentType: "application/x.zalando.customer.checkout.create.response+json",
            path: "checkouts",
            parameters: parameters)
    }

    func updateCheckout(checkoutId: String, parameters: [String: AnyObject]) -> EndpointType {
        return APIEndpoint(baseURL: self.config.checkoutAPIURL,
            method: .PUT,
            contentType: "application/x.zalando.customer.checkout.update+json",
            acceptedContentType: "application/x.zalando.customer.checkout.update.response+json",
            path: "checkouts/\(checkoutId)",
            parameters: parameters)
    }

    func createOrder(parameters parameters: [String: AnyObject]) -> EndpointType {
        return APIEndpoint(baseURL: self.config.checkoutAPIURL,
            method: .POST,
            contentType: "application/x.zalando.customer.order.create+json",
            acceptedContentType: "application/x.zalando.customer.order.create.response+json",
            path: "orders",
            parameters: parameters)
    }

    func deleteAddress(addressId: String) -> EndpointType {
        let queryItems = NSURLQueryItem.build(
            ["sales_channel": self.config.salesChannel, "address_id": addressId])
        return APIEndpoint(baseURL: self.config.checkoutAPIURL,
            method: .DELETE,
            path: "addresses/\(addressId)",
            queryItems: queryItems)
    }

    func makeFetchAddressListEndpoint(salesChannel: String) -> EndpointType {
        return APIEndpoint(baseURL: self.config.checkoutAPIURL,
            method: .GET,
            acceptedContentType: "application/x.zalando.customer.addresses+json",
            path: "addresses",
            queryItems: [
                NSURLQueryItem(name: "sales_channel", value: salesChannel)
        ])
    }
}
