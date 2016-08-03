//
//  Copyright © 2016 Zalando SE. All rights reserved.
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
