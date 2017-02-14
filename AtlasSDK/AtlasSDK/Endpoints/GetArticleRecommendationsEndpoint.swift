//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

struct GetArticleRecommendationsEndpoint: CatalogEndpoint {

    let config: Config

    var path: String { return "articles/\(sku)/recommendations" }
    let acceptedContentType = "application/x.zalando.article.recommendation+json"
    var queryItems: [URLQueryItem]? {
        return URLQueryItem.build(from: ["client_id": clientId ])
    }

    let sku: String

    init(config: Config, sku: String) {
        self.config = config
        self.sku = sku
    }

}
