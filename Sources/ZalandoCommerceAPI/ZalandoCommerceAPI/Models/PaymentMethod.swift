//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct PaymentMethod {

    public let method: PaymentMethodType
    public let metadata: PaymentMetadata?
    public let isExternalPayment: Bool

}

extension PaymentMethod: JSONInitializable {

    fileprivate struct Keys {
        static let method = "method"
        static let metadata = "metadata"
        static let externalPayment = "external_payment"
    }

    init?(json: JSON) {
        guard
            let method = PaymentMethodType(rawValue: json[Keys.method].string),
            let isExternalPayment = json[Keys.externalPayment].bool else { return nil }

        self.init(method: method,
                  metadata: PaymentMetadata(json: json[Keys.metadata]),
                  isExternalPayment: isExternalPayment)
    }

}
