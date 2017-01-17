//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import AtlasSDK
import SwiftyJSON

struct DemoCatalog {

    let articles: [DemoArticle]

}

extension DemoCatalog {

    init(data: Data, rootElement: String = "content") {
        let json = JSON(data: data)
        articles = json[rootElement].arrayValue.flatMap { DemoArticle(json: $0) }
    }

}
