//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct GetGuestCheckoutEndpoint: ConfigurableEndpoint, SalesChannelEndpoint {

    let serviceURL: URL
    var path: String { return "guest-checkout/api/checkouts/\(checkoutId)/\(token)" }
    let acceptedContentType = "application/x.zalando.guest-checkout+json"
    let salesChannel: String

    let checkoutId: String
    let token: String

}
