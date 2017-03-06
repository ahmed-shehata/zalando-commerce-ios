//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

/**
 Header Configuration needed to the get better recommendations
 
 - Note: Please contact us to figure out the best recommendations properties for you
 */
public struct RecommendationConfig {

    /// Recommendation type like similar product or product from the same brand
    public let type: String

    /// Recommendation location as where it is disaplyed in the channel
    public let location: String

    /// Recommendation channel used to display the recommendation like web or mobile
    public let channel: String

    public init(type: String, location: String, channel: String) {
        self.type = type
        self.location = location
        self.channel = channel
    }

}

struct GetArticleRecommendationsEndpoint: CatalogEndpoint {

    let config: Config

    var path: String { return "articles/\(sku.value)/recommendations" }
    let acceptedContentType = "application/x.zalando.article.recommendation+json"
    var queryItems: [URLQueryItem]? {
        return URLQueryItem.build(from: ["client_id": clientId ])
    }
    var headers: EndpointHeaders? {
        return [
            "X-Sales-Channel": salesChannel,
            "X-Reco-Type": recommendationConfig.type,
            "X-Reco-Location": recommendationConfig.location,
            "X-Channel": recommendationConfig.channel]
    }

    let sku: ConfigSKU
    let recommendationConfig: RecommendationConfig

    init(config: Config, sku: ConfigSKU, recommendationConfig: RecommendationConfig) {
        self.config = config
        self.sku = sku
        self.recommendationConfig = recommendationConfig
    }

}
