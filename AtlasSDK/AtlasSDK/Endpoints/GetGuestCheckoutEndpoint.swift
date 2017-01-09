//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

struct GetGuestCheckoutEndpoint: CheckoutGatewayEndpoint {

    let config: Config

    var path: String { return "guest-checkout/api/checkouts/\(checkoutId)/\(token)" }
    let acceptedContentType = "application/x.zalando.guest-checkout+json"
    let checkoutId: String
    let token: String

}
