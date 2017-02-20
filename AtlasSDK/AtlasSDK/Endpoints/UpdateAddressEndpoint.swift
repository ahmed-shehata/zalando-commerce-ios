//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

struct UpdateAddressEndpoint: CheckoutEndpoint {

    let config: Config

    let method: HTTPMethod = .PUT
    var path: String { return "addresses/\(addressId)" }
    let acceptedContentType = "application/x.zalando.customer.address.update.response+json"
    let contentType = "application/x.zalando.customer.address.update+json"

    var parameters: EndpointParameters? {
        return updateAddressRequest.toJSON()
    }

    let addressId: AddressId
    let updateAddressRequest: UpdateAddressRequest

}
