//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct CreateCheckoutEndpoint: CheckoutEndpoint {

    let config: Config

    let method: HTTPMethod = .POST
    let path = "checkouts"
    let contentType = "application/x.zalando.customer.checkout.create+json"
    let acceptedContentType = "application/x.zalando.customer.checkout.create.response+json"
    let parameters: EndpointParameters?

}
