//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct CreateCartEndpoint: ConfigurableEndpoint {

    let serviceURL: NSURL
    let method: HTTPMethod = .POST
    let path = "carts"
    let contentType = "application/x.zalando.cart.create+json"
    let acceptedContentType = "application/x.zalando.cart.create.response+json"
    let parameters: [String: AnyObject]?

}
