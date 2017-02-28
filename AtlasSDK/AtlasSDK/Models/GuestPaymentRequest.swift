//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct GuestPaymentRequest {

    public let method: String
    public let metadata: [String: Any]?

    public init(method: String, metadata: [String: Any]?) {
        self.method = method
        self.metadata = metadata
    }

}

extension GuestPaymentRequest: JSONRepresentable {

    private struct Keys {
        static let method = "method"
        static let metadata = "metadata"
    }

    public func toJSON() -> [String: Any] {
        return [
            Keys.method: self.method,
            Keys.metadata: metadata as Any
        ]
    }

}
