//
//  Copyright © 2016 Zalando SE. All rights reserved.
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
        self.init(method: PaymentMethodType(rawValue: json[Keys.method].stringValue),
            metadata: json[Keys.metadata].dictionaryObject)
    }

}
