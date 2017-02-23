//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct CartItem {

    public let sku: SimpleSKU
    public let quantity: Int

}

extension CartItem: JSONInitializable {

    fileprivate struct Keys {
        static let sku = "sku"
        static let quantity = "quantity"
    }

    init?(json: JSON) {
        guard let sku = json[Keys.sku].string,
            let quantity = json[Keys.quantity].int
            else { return nil }
        self.init(sku: SimpleSKU(value: sku), quantity: quantity)
    }
}
