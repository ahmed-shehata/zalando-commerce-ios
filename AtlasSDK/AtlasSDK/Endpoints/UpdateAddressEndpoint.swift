//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct UpdateAddressEndPoint: ConfigurableEndpoint {

    let serviceURL: NSURL
    let method: HTTPMethod = .PUT
    var path: String { return "addresses/\(addressId)" }
    let acceptedContentType = "application/x.zalando.customer.address.update.response+json"
    let contentType = "application/x.zalando.customer.address.update+json"
    var queryItems: [NSURLQueryItem]? {
        return NSURLQueryItem.build(["sales_channel": salesChannel])
    }

    var parameters: [String: AnyObject]? {
        return updateAddressRequest.toJSON()
    }

    let addressId: String
    let updateAddressRequest: UpdateAddressRequest
    let salesChannel: String

}
