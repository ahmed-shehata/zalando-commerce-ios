//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct GetArticleEndpoint: ConfigurableEndpoint, SalesChannelEndpoint {

    let serviceURL: NSURL
    var path: String { return "articles/\(skus)" }
    let acceptedContentType = "application/x.zalando.article+json"
    let skus: String
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
