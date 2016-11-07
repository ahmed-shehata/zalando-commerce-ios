//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct GetCustomerEndpoint: ConfigurableEndpoint, SalesChannelEndpoint {

    var serviceURL: NSURL
    let path = "customer"
    let acceptedContentType = "application/x.zalando.customer+json"
    let salesChannel: String

}
