//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct GetArticleEndpoint: ConfigurableEndpoint, SalesChannelEndpoint {

    let serviceURL: URL
    var path: String { return "articles/\(sku)" }
    let acceptedContentType = "application/x.zalando.article+json"
    let sku: String
    var queryItems: [URLQueryItem]? {
        return URLQueryItem.build(from: [
            "client_id": clientId as Optional<AnyObject>,
            "fields": fields?.joined(separator: ",") as Optional<AnyObject>
        ])
    }

    let salesChannel: String
    let clientId: String
    let fields: [String]?
    let requiresAuthorization = false
}
