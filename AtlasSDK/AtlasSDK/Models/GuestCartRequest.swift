//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

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

    public func toJSON() -> [String: Any] {
        return [Keys.items: self.items.map { $0.toJSON() }]
    }

}
