//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import ZalandoCommerceAPI
import Freddy

struct DemoCatalog {

    let articles: [DemoArticle]

}

extension DemoCatalog {

    init(data: Data, rootElement: String = "content") {
        guard let json = try? JSON(data: data),
            let rootArray = try? json.getArray(at: rootElement) else {
                articles = []
                return
        }
        articles = rootArray.flatMap { try? DemoArticle(json: $0) }
    }

}
