//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

public struct Coupon {

    public let coupon: String
    public let warning: String?
    public let error: String?
    public let discount: Discount?

}

extension Coupon {

    public struct Discount {
        public let gross: Money
        public let tax: Money
        public let remaining: Money
    }

}

extension Coupon.Discount: JSONInitializable {

    private struct Keys {
        static let gross = "gross"
        static let tax = "tax"
        static let remaining = "remaining"
    }

    init?(json: JSON) {
        guard
            let gross = Money(json: json[Keys.gross]),
            let tax = Money(json: json[Keys.tax]),
            let remaining = Money(json: json[Keys.remaining]) else { return nil }

        self.init(gross: gross, tax: tax, remaining: remaining)
    }

}

extension Coupon: JSONInitializable {

    private struct Keys {
        static let coupon = "coupon"
        static let warning = "warning"
        static let error = "error"
        static let discount = "discount"
    }

    init?(json: JSON) {
        guard let coupon = json[Keys.coupon].string else { return nil }

        self.init(coupon: coupon,
                  warning: json[Keys.warning].string,
                  error: json[Keys.error].string,
                  discount: Discount(json: json[Keys.discount]))
    }

}
