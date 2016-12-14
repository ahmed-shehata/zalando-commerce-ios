//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct CreateGuestOrderEndpoint: CheckoutGatewayEndpoint {

    let method: HTTPMethod = .POST
    let path = "guest-checkout/api/orders"
    let contentType = "application/x.zalando.order.create+json"
    let acceptedContentType = "application/x.zalando.order.create.response+json"
    let parameters: EndpointParameters?

    let config: Config

    init(config: Config, parameters: EndpointParameters?) {
        self.config = config
        self.parameters = parameters
    }

}
