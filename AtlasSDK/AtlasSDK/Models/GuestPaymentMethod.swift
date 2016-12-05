//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

public struct GuestPaymentMethod {

    public let method: String
    public let metadata: [String: Any]?
    public let externalPayment: Bool?

}

extension GuestPaymentMethod: JSONInitializable {

    private struct Keys {
        static let method = "method"
        static let metadata = "metadata"
        static let externalPayment = "external_payment"
    }

    init?(json: JSON) {
        guard let method = json[Keys.method].string else { return nil }

        self.init(method: method,
                  metadata: json[Keys.metadata].dictionaryObject,
                  externalPayment: json[Keys.externalPayment].bool)
    }

}
