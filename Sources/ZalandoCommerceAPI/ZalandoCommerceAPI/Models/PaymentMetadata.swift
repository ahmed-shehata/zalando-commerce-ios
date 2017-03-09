//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

public struct PaymentMetadata {

    public let metadata: [String: Any]?
    public let creditCardSuffix: String?
    public let creditCardPrefix: String?

}

extension PaymentMetadata {

    public var creditCardNumber: String? {
        guard let suffix = creditCardSuffix else { return nil }
        let prefix = creditCardPrefix ?? ""
        let availableLength = (prefix + suffix).length
        let secured = "".padding(toLength: 16 - availableLength, withPad: "x", startingAt: 0)
        return prefix + secured + suffix
    }

}

extension PaymentMetadata: JSONInitializable {

    fileprivate struct Keys {
        static let creditCardSuffix = "pan_suffix"
        static let creditCardPrefix = "pan_prefix"
    }

    init?(json: JSON) {
        self.init(metadata: json.dictionary,
                  creditCardSuffix: json.dictionary?[Keys.creditCardSuffix] as? String,
                  creditCardPrefix: json.dictionary?[Keys.creditCardPrefix] as? String)
    }

}
