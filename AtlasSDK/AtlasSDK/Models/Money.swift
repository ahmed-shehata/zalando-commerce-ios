//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct Money {
    public let amount: NSDecimalNumber
    public let currency: String
}

extension Money: Hashable {
    public var hashValue: Int {
        return (17 &* amount.hashValue) &+ currency.hashValue
    }
}

public func == (lhs: Money, rhs: Money) -> Bool {
    return lhs.amount.isEqual(rhs.amount) && lhs.currency == rhs.currency
}

extension Money: JSONInitializable {

    private struct Keys {
        static let amount = "amount"
        static let currency = "currency"
    }

    init?(json: JSON) {
        guard let amount = json[Keys.amount].number,
            currency = json[Keys.currency].string else { return nil }
        self.init(amount: NSDecimalNumber(decimal: amount.decimalValue),
                  currency: currency)
    }
}
