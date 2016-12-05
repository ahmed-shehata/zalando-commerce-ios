//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct CreateCheckoutEndpoint: ConfigurableEndpoint, SalesChannelEndpoint {

    let serviceURL: URL
    let method: HTTPMethod = .POST
    let path = "checkouts"
    let contentType = "application/x.zalando.customer.checkout.create+json"
    let acceptedContentType = "application/x.zalando.customer.checkout.create.response+json"
    let parameters: [String: Any]?
    let salesChannel: String

}
