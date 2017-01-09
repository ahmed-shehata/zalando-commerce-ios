//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

struct CreateAddressEndpoint: CheckoutEndpoint {

    let config: Config

    let method: HTTPMethod = .POST
    let path = "addresses"
    let acceptedContentType = "application/x.zalando.customer.address.create.response+json"
    let contentType = "application/x.zalando.customer.address.create+json"

    var parameters: EndpointParameters? {
        return createAddressRequest.toJSON()
    }

    let createAddressRequest: CreateAddressRequest

}
