//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol EndpointType {

    var baseURL: NSURL { get }
    var method: HTTPMethod { get }
    var contentType: String { get }
    var path: String { get }
    var queryItems: [NSURLQueryItem]? { get }
    var parameters: [String: AnyObject]? { get }
    var URL: NSURL { get }

}

struct APIEndpoint: EndpointType {

    let baseURL: NSURL

    let method: HTTPMethod
    let contentType: String
    let path: String

    let queryItems: [NSURLQueryItem]?
    let parameters: [String: AnyObject]?

    var URL: NSURL {
        let urlComponents = NSURLComponents(validURL: baseURL)
        urlComponents.queryItems = self.queryItems
        return urlComponents.validURL.URLByAppendingPathComponent(self.path)
    }

    private init(baseURL: NSURL,
        method: HTTPMethod = .GET,
        contentType: String = "application/json",
        path: String,
        queryItems: [NSURLQueryItem]? = nil,
        parameters: [String: AnyObject]? = nil) {
            self.baseURL = baseURL
            self.method = method
            self.contentType = contentType
            self.path = path

            self.queryItems = queryItems
            self.parameters = parameters
    }

}

extension APIEndpoint {

    static func customers(baseURL: NSURL) -> EndpointType {
        return APIEndpoint(baseURL: baseURL, path: "/customer")
    }

    static func articles(baseURL: NSURL, salesChannel: String, sku: String? = nil, fields: [String]? = nil) -> EndpointType {
        let path = "/articles/\(sku ?? "")"
        let queryItems = NSURLQueryItem.build(["sales_channel": salesChannel, "fields": fields?.joinWithSeparator(",")])
        return APIEndpoint(baseURL: baseURL, path: path, queryItems: queryItems)
    }

    static func createCart(baseURL: NSURL, parameters: [String: AnyObject]) -> EndpointType {
        return APIEndpoint(baseURL: baseURL,
            method: .POST,
            contentType: "application/x.zalando.cart.create+json",
            path: "/carts",
            parameters: parameters)
    }

    static func createCheckout(baseURL: NSURL, parameters: [String: AnyObject]) -> EndpointType {
        return APIEndpoint(baseURL: baseURL,
            method: .POST,
            contentType: "application/x.zalando.customer.checkout.create+json",
            path: "/checkouts",
            parameters: parameters)
    }

}
