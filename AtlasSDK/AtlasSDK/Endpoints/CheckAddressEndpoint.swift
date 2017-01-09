//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

struct CheckAddressEndpoint: CheckoutEndpoint {

    let config: Config

    let method: HTTPMethod = .POST
    let path = "address-checks"
    let acceptedContentType = "application/x.zalando.address-check.create.response+json"
    let contentType = "application/x.zalando.address-check.create+json"

    var parameters: EndpointParameters? {
        return checkAddressRequest.toJSON()
    }

    let checkAddressRequest: CheckAddressRequest

}
