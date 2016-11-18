//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct DeleteAddressEndpoint: ConfigurableEndpoint, SalesChannelEndpoint {

    let serviceURL: URL
    let method: HTTPMethod = .DELETE
    var path: String { return "addresses/\(addressId)" }
    let acceptedContentType = "application/x.zalando.customer.addresses+json"
    var queryItems: [URLQueryItem]? {
        return URLQueryItem.build(["address_id": addressId as Optional<AnyObject>])
    }

    let addressId: String
    let salesChannel: String

}
