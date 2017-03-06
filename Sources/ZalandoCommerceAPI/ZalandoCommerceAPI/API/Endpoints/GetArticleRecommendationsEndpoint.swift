//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

struct GetArticleRecommendationsEndpoint: CatalogEndpoint {

    let config: Config

    var path: String { return "articles/\(sku.value)/recommendations" }
    let acceptedContentType = "application/x.zalando.article.recommendation+json"
    var queryItems: [URLQueryItem]? {
        return URLQueryItem.build(from: ["client_id": clientId ])
    }

    let sku: ConfigSKU

    init(config: Config, sku: ConfigSKU) {
        self.config = config
        self.sku = sku
    }

}
