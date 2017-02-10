//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

// swiftlint:disable missing_docs

import Foundation

public struct GuestCartRequest {

    public let items: [CartItemRequest]

    public init(items: [CartItemRequest]) {
        self.items = items
    }

}

extension GuestCartRequest: JSONRepresentable {

    private struct Keys {
        static let items = "items"
    }

    func toJSON() -> JSONDictionary {
        return [Keys.items: self.items.map { $0.toJSON() }]
    }

}
