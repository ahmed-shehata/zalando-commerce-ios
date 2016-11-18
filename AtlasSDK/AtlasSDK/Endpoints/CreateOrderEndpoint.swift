//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct CreateOrderEndpoint: ConfigurableEndpoint, SalesChannelEndpoint {

    let serviceURL: URL
    let method: HTTPMethod = .POST
    let path = "orders"
    let contentType = "application/x.zalando.customer.order.create+json"
    let acceptedContentType = "application/x.zalando.customer.order.create.response+json"
    let parameters: [String: AnyObject]?
    let salesChannel: String

    let checkoutId: String

}
