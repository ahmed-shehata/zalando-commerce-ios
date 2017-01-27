//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

public struct GuestPaymentMethod {

    public let method: PaymentMethodType
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
        guard let rawValue = json[Keys.method].string else { return nil }

        self.init(method: PaymentMethodType(rawValue: rawValue),
                  metadata: json[Keys.metadata].dictionary,
                  externalPayment: json[Keys.externalPayment].bool)
    }

}
