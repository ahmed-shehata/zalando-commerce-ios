//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct PaymentMethod {

    public let method: PaymentMethodType?
    public let metadata: [String: Any]?

}

extension PaymentMethod: JSONInitializable {

    fileprivate struct Keys {
        static let method = "method"
        static let metadata = "metadata"
    }

    init?(json: JSON) {
        var paymentMethod: PaymentMethodType?
        if let methodRawValue = json[Keys.method].string {
            paymentMethod = PaymentMethodType(rawValue: methodRawValue)
        }
        self.init(method: paymentMethod,
                  metadata: json[Keys.metadata].dictionary)
    }

}
