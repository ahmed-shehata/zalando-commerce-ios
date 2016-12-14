//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

struct GetArticleEndpoint: CatalogEndpoint {

    let config: Config

    var path: String { return "articles/\(sku)" }
    let acceptedContentType = "application/x.zalando.article+json"
    var queryItems: [URLQueryItem]? {
        return URLQueryItem.build(from: [
            "client_id": clientId,
            "fields": fields?.joined(separator: ",")
        ])
    }

    let sku: String
    let fields: [String]?

}
