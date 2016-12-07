//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct UpdateCheckoutEndpoint: ConfigurableEndpoint, SalesChannelEndpoint {

    let serviceURL: URL
    let method: HTTPMethod = .PUT
    var path: String { return "checkouts/\(checkoutId)" }
    let contentType = "application/x.zalando.customer.checkout.update+json"
    let acceptedContentType = "application/x.zalando.customer.checkout.update.response+json"
    let parameters: EndpointParameters?
    let salesChannel: String

    let checkoutId: String

}
