//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

public struct DemoCatalog {

    public let articles: [DemoArticle]

}

extension DemoCatalog {

    public init(jsonString: String, rootElement: String = "content") {
        let json = JSON.parse(jsonString)
        articles = json[rootElement].arrayValue.flatMap { DemoArticle(json: $0) }
    }

}
