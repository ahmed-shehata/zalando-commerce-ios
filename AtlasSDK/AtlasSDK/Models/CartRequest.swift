//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

// swiftlint:disable missing_docs

import Foundation

public struct CartRequest {

    public let items: [CartItemRequest]
    public let replaceItems: Bool

    public init(items: [CartItemRequest], replaceItems: Bool = true) {
        self.items = items
        self.replaceItems = replaceItems
    }

}

extension CartRequest: JSONRepresentable {

    func toJSON() -> JSONDictionary {
        return [
            "replace_items": self.replaceItems,
            "items": self.items.map { $0.toJSON() }
        ]
    }

}
