//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct GetCustomerEndpoint: CheckoutEndpoint {

    let path = "customer"
    let acceptedContentType = "application/x.zalando.customer+json"
    let config: Config

}
