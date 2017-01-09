//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import AtlasSDK
import SwiftyJSON

struct DemoCatalog {

    let articles: [DemoArticle]

}

extension DemoCatalog {

    init(jsonString: String, rootElement: String = "content") {
        let json = JSON.parse(jsonString)
        articles = json[rootElement].arrayValue.flatMap { DemoArticle(json: $0) }
    }

}
