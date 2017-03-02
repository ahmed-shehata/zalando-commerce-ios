//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct Recommendation {

    public let id: ConfigSKU
    public let name: String
    public let brand: Brand
    public let lowestPrice: Money
    public let media: Media?

}

extension Recommendation: JSONInitializable {

    init?(json: JSON) {
        guard let id = json["id"].string,
            let name = json["name"].string,
            let brand = Brand(json: json["brand"]),
            let lowestPrice = Money(json: json["lowest_price"])
            else { return nil }

        self.id = ConfigSKU(value: id)
        self.name = name
        self.brand = brand
        self.lowestPrice = lowestPrice
        self.media = Media(json: json["media"])
    }

}
