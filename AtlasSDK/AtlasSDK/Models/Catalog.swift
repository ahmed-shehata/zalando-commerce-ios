//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

public struct Catalog {

    public let articles: [Article]

}

extension Catalog: JSONInitializable {

    init?(json: JSON) {
        articles = json.arrayValue.flatMap { Article(json: $0) }
    }

}
