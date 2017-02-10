//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

// swiftlint:disable missing_docs

import Foundation

public struct OrderRequest {

    public let checkoutId: String

    public init(checkoutId: String) {
        self.checkoutId = checkoutId
    }

}

extension OrderRequest: JSONRepresentable {

    func toJSON() -> JSONDictionary {
        return [
            "checkout_id": self.checkoutId
        ]
    }

}
