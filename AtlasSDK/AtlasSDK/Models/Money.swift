//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

public typealias MoneyAmount = NSDecimalNumber

public struct Money {

    public static let Zero = Money(amount: 0, currency: "")

    public let amount: MoneyAmount
    public let currency: String

    public init(amount: MoneyAmount, currency: String) {
        self.amount = amount
        self.currency = currency
    }

}

extension Money: Comparable { }

extension Money: Hashable {

    public var hashValue: Int {
        return (17 &* amount.hashValue) &+ currency.hashValue
    }

}

public func == (lhs: Money, rhs: Money) -> Bool {
    return lhs.amount.isEqual(rhs.amount) && lhs.currency == rhs.currency
}

public func < (lhs: Money, rhs: Money) -> Bool {
    return lhs.amount < rhs.amount
}

extension Money: CustomStringConvertible {

    public var description: String {
        return "Money: { amount: \(self.amount), currency: \(self.currency) }"
    }

}

extension Money: JSONInitializable {

    fileprivate struct Keys {
        static let amount = "amount"
        static let currency = "currency"
    }

    init?(json: JSON) {
        guard let amount = json[Keys.amount].number,
            let currency = json[Keys.currency].string
            else { return nil }

        self.init(amount: MoneyAmount(decimal: amount.decimalValue), currency: currency)
    }

}
