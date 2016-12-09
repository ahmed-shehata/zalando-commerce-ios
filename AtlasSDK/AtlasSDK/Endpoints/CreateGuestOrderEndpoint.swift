//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct CreateGuestOrderEndpoint: ConfigurableEndpoint {

    let serviceURL: URL
    let method: HTTPMethod = .POST
    let path = "guest-checkout/api/orders"
    let contentType = "application/x.zalando.order.create+json"
    let acceptedContentType = "application/x.zalando.order.create.response+json"
    let parameters: EndpointParameters?
    var headers: EndpointHeaders? { return ["X-UID": clientId, "X-Sales-Channel": salesChannel] }
    let salesChannel: String
    let clientId: String

}
