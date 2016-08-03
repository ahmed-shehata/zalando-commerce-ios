//
//  Copyright © 2016 Zalando SE. All rights reserved.
//


public struct Unit {
    public let id: String
    public let size: String
    public let price: Price
    public let originalPrice: Price
    public let available: Bool
    public let stock: Int
}

extension Unit: JSONInitializable {

    private struct Keys {
        static let id = "id"
        static let size = "size"
        static let price = "price"
        static let originalPrice = "original_price"
        static let available = "available"
        static let stock = "stock"
    }

    init?(json: JSON) {
        guard let
        id = json[Keys.id].string,
            size = json[Keys.size].string,
            price = Price(json: json[Keys.price]),
            originalPrice = Price(json: json[Keys.originalPrice]),
            available = json[Keys.available].bool,
            stock = json[Keys.available].int else { return nil }
        self.init(id: id,
            size: size,
            price: price,
            originalPrice: originalPrice,
            available: available,
            stock: stock)
    }
}

extension Unit: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
}

public func == (lhs: Unit, rhs: Unit) -> Bool {
    return lhs.id == rhs.id
}
