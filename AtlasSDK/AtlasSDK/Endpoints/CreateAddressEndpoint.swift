//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct CreateAddressEndpoint: ConfigurableEndpoint {

    let serviceURL: NSURL
    let method: HTTPMethod = .POST
    var path: String { return "addresses" }
    let acceptedContentType = "application/x.zalando.customer.address.create.response+json"
    let contentType = "application/x.zalando.customer.address.create+json"
    var queryItems: [NSURLQueryItem]? {
        return NSURLQueryItem.build(["sales_channel": salesChannel])
    }

    var parameters: [String: AnyObject]? {
        return createAddressRequest.toJSON()
    }

    let createAddressRequest: CreateAddressRequest
    let salesChannel: String

}
