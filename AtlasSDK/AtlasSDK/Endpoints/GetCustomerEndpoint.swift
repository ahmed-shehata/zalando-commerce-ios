//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

struct GetCustomerEndpoint: CheckoutEndpoint {

    let path = "customer"
    let acceptedContentType = "application/x.zalando.customer+json"
    let config: Config

}
