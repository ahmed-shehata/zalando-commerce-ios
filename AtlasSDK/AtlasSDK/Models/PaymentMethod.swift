//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct PaymentMethod {

    public let method: String?
    public let metadata: [String: AnyObject]?

}

extension PaymentMethod: JSONInitializable {

    fileprivate struct Keys {
        static let method = "method"
        static let metadata = "metadata"
    }

    init?(json: JSON) {
        self.init(method: json[Keys.method].string,
            metadata: json[Keys.metadata].dictionaryObject as [String : AnyObject]?)
    }

}
