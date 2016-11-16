//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct CreateAddressEndpoint: ConfigurableEndpoint, SalesChannelEndpoint {

    let serviceURL: NSURL
    let method: HTTPMethod = .POST
    let path = "addresses"
    let acceptedContentType = "application/x.zalando.customer.address.create.response+json"
    let contentType = "application/x.zalando.customer.address.create+json"

    var parameters: [String: AnyObject]? {
        return createAddressRequest.toJSON()
    }

    let createAddressRequest: CreateAddressRequest
    let salesChannel: String

}
