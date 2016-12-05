//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

public struct CartItem {
    public let sku: String
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
        self.init(sku: sku, quantity: quantity)
    }
}
