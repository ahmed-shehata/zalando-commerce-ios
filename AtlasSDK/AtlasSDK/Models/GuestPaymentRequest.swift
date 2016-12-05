//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

public struct GuestPaymentRequest {

    public let method: String
    public let metadata: [String: AnyObject]?

    public init(method: String, metadata: [String: AnyObject]?) {
        self.method = method
        self.metadata = metadata
    }

}

extension GuestPaymentRequest: JSONRepresentable {

    private struct Keys {
        static let method = "method"
        static let metadata = "metadata"
    }

    public func toJSON() -> [String : Any] {
        var json: [String: Any] = [
            Keys.method: self.method
        ]
        json[Keys.metadata] = metadata
        return json
    }

}
