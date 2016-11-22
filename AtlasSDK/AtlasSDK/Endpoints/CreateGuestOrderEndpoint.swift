//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct CreateGuestOrderEndpoint: ConfigurableEndpoint, SalesChannelEndpoint {

    let serviceURL: NSURL
    let method: HTTPMethod = .POST
    let path = "orders"
    let contentType = "application/x.zalando.customer.create.create+json"
    let acceptedContentType = "application/x.zalando.customer.order.create.response+json"
    let parameters: [String: AnyObject]?
    let salesChannel: String

}
