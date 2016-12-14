//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct CompleteGuestOrderEndpoint: ConfigurableEndpoint, ClientIdEndpoint {

    let serviceURL: URL
    let method: HTTPMethod = .POST
    let path = "guest-checkout/api/orders"
    let contentType = "application/x.zalando.order.create.continue+json"
    let acceptedContentType = "application/x.zalando.order.create.response+json"
    let parameters: EndpointParameters?
    let salesChannel: String
    let clientId: String

    init(config: Config, parameters: EndpointParameters?) {
        self.parameters = parameters
        serviceURL = config.checkoutGatewayURL
        salesChannel = config.salesChannel.identifier
        clientId = config.clientId
    }

}
