//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

struct DeleteAddressEndpoint: CheckoutEndpoint {

    let config: Config

    let method: HTTPMethod = .DELETE
    var path: String { return "addresses/\(addressId)" }
    let acceptedContentType = "application/x.zalando.customer.addresses+json"
    var queryItems: [URLQueryItem]? {
        return URLQueryItem.build(from: ["address_id": addressId])
    }

    let addressId: String

}
