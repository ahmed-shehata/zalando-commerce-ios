//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct GetAddressesEndpoint: ConfigurableEndpoint, SalesChannelEndpoint {

    let serviceURL: NSURL
    let path = "addresses"
    let acceptedContentType = "application/x.zalando.customer.addresses+json"

    let salesChannel: String

}
