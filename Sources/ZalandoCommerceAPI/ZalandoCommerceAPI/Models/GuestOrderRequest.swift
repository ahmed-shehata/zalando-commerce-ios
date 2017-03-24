//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct GuestOrderRequest {

    public let guestCheckoutId: GuestCheckoutId

    public init(guestCheckoutId: GuestCheckoutId) {
        self.guestCheckoutId = guestCheckoutId
    }

}

extension GuestOrderRequest: JSONRepresentable {

    private struct Keys {
        static let checkoutId = "checkout_id"
        static let token = "token"
    }

    func toJSON() -> JSONDictionary {
        return [
            Keys.checkoutId: guestCheckoutId.checkoutId,
            Keys.token: guestCheckoutId.token
        ]
    }

}
