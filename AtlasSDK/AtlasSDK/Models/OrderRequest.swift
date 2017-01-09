//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

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
