//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct GuestCustomerRequest {

    public let email: String
    public let subscribeNewsletter: Bool

}

extension GuestCustomerRequest: JSONRepresentable {

    private struct Keys {
        static let email = "email"
        static let subscribeNewsletter = "subscribe_newsletter"
    }

    public init(guestEmail: String, subscribeNewsletter: Bool) {
        self.email = guestEmail
        self.subscribeNewsletter = subscribeNewsletter
    }

    func toJSON() -> JSONDictionary {
        return [
            Keys.email: email,
            Keys.subscribeNewsletter: subscribeNewsletter
        ]
    }

}
