//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct Price {
    public let amount: MoneyAmount
    public let currency: String
}

extension Price: Hashable {
    public var hashValue: Int {
        return (17 &* amount.hashValue) &+ currency.hashValue
    }
}

public func == (lhs: Price, rhs: Price) -> Bool {
    return lhs.amount.isEqual(rhs.amount) && lhs.currency == rhs.currency
}

extension Price: JSONInitializable {

    private struct Keys {
        static let amount = "amount"
        static let currency = "currency"
    }

    init?(json: JSON) {
        guard let amount = json[Keys.amount].number,
            currency = json[Keys.currency].string else { return nil }
        self.init(amount: MoneyAmount(decimal: amount.decimalValue),
            currency: currency)
    }

}
