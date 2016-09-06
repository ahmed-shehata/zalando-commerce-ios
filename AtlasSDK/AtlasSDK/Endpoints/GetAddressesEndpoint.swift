//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct GetAddressesEndpoint: ConfigurableEndpoint {

    let serviceURL: NSURL
    let path = "addresses"
    let acceptedContentType = "application/x.zalando.customer.addresses+json"
    var queryItems: [NSURLQueryItem]? {
        return NSURLQueryItem.build(["sales_channel": salesChannel])
    }

    let salesChannel: String

}
