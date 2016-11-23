//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

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

    public func toJSON() -> [String: AnyObject] {
        return [
            Keys.email: email,
            Keys.subscribeNewsletter: subscribeNewsletter
        ]
    }

}
