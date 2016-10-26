//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct DeleteAddressEndpoint: ConfigurableEndpoint, SalesChannelEndpoint {

    let serviceURL: NSURL
    let method: HTTPMethod = .DELETE
    var path: String { return "addresses/\(addressId)" }
    let acceptedContentType = "application/x.zalando.customer.addresses+json"
    var queryItems: [NSURLQueryItem]? {
        return NSURLQueryItem.build(["sales_channel": salesChannel, "address_id": addressId])
    }

    let addressId: String
    let salesChannel: String

}
