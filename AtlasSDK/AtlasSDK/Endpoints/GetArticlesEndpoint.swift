//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct GetArticlesEndpoint: ConfigurableEndpoint, SalesChannelEndpoint {

    let serviceURL: NSURL
    var path: String { return "articles" }
    let acceptedContentType = "application/x.zalando.article+json"
    let skus: [String]
    var queryItems: [NSURLQueryItem]? {
        let items: [String: AnyObject?] = [
            "sales_channel": salesChannel,
            "client_id": clientId,
            "fields": fields?.joinWithSeparator(","),
            "articleId": skus.joinWithSeparator(",")
        ]

        return NSURLQueryItem.build(items)
    }

    let salesChannel: String
    let clientId: String
    let fields: [String]?
    let requiresAuthorization = false
}
