//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

struct GetAddressesEndpoint: CheckoutEndpoint {

    let config: Config

    let path = "addresses"
    let acceptedContentType = "application/x.zalando.customer.addresses+json"

}
