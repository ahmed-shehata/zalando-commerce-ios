//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct CheckAddressEndpoint: ConfigurableEndpoint, SalesChannelEndpoint {

    let serviceURL: URL
    let method: HTTPMethod = .POST
    let path = "address-checks"
    let acceptedContentType = "application/x.zalando.address-check.create.response+json"
    let contentType = "application/x.zalando.address-check.create+json"

    var parameters: [String: AnyObject]? {
        return checkAddressRequest.toJSON()
    }

    let checkAddressRequest: CheckAddressRequest
    let salesChannel: String

}
