//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct UpdateAddressEndpoint: ConfigurableEndpoint, SalesChannelEndpoint {

    let serviceURL: NSURL
    let method: HTTPMethod = .PUT
    var path: String { return "addresses/\(addressId)" }
    let acceptedContentType = "application/x.zalando.customer.address.update.response+json"
    let contentType = "application/x.zalando.customer.address.update+json"

    var parameters: [String: AnyObject]? {
        return updateAddressRequest.toJSON()
    }

    let addressId: String
    let updateAddressRequest: UpdateAddressRequest
    let salesChannel: String

}
