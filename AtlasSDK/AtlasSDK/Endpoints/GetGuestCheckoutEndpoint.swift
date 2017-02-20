//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

public typealias CheckoutToken = String

struct GetGuestCheckoutEndpoint: CheckoutGatewayEndpoint {

    let config: Config

    var path: String { return "guest-checkout/api/checkouts/\(checkoutId)/\(token)" }
    let acceptedContentType = "application/x.zalando.guest-checkout+json"

    let checkoutId: CheckoutId
    let token: CheckoutToken

}
