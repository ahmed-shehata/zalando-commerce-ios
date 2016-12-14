//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct CreateCartEndpoint: CheckoutEndpoint {

    let config: Config

    let method: HTTPMethod = .POST
    let path = "carts"
    let contentType = "application/x.zalando.cart.create+json"
    let acceptedContentType = "application/x.zalando.cart.create.response+json"
    let parameters: EndpointParameters?

}
