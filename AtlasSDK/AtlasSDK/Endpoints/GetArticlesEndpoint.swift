//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct GetArticleEndpoint: ConfigurableEndpoint, SalesChannelEndpoint {

    let serviceURL: NSURL
    var path: String { return "articles/\(sku)" }
    let acceptedContentType = "application/x.zalando.article+json"
    let sku: String
    var queryItems: [NSURLQueryItem]? {
        return NSURLQueryItem.build([
            "sales_channel": salesChannel,
            "client_id": clientId,
            "fields": fields?.joinWithSeparator(",")
        ])
    }

    let salesChannel: String
    let clientId: String
    let fields: [String]?
    let requiresAuthorization = false
}
