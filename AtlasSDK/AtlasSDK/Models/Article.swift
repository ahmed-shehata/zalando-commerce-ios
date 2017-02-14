//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct Article {

    public let id: String
    public let name: String
    public let color: String
    public let brand: Brand
    public let units: [Unit]
    public let availableUnits: [Unit]
    public let media: Media

    public var hasSingleUnit: Bool {
        return units.count == 1
    }

    public var hasAvailableUnits: Bool {
        return !availableUnits.isEmpty
    }

    public var thumbnailURL: URL? {
        return media.images.first?.catalogURL
    }

    public struct Unit {
        public let id: String
        public let size: String
        public let price: Money
        public let originalPrice: Money
        public let available: Bool
        public let stock: Int?
        public let partner: Partner?
    }

    public struct Partner {
        public let id: String
        public let name: String
        public let detailsURL: String
    }

}

extension Article: JSONInitializable {

    init?(json: JSON) {
        guard let id = json["id"].string,
            let name = json["name"].string,
            let color = json["color"].string,
            let brand = Brand(json: json["brand"]),
            let media = Media(json: json["media"])
            else { return nil }

        self.id = id
        self.name = name
        self.color = color
        self.media = media
        self.brand = brand
        self.units = json["units"].jsons.flatMap { Article.Unit(json: $0) }
        self.availableUnits = units.filter { $0.available }
    }

}

extension Article.Unit: JSONInitializable {

    init?(json: JSON) {
        guard let id = json["id"].string,
            let size = json["size"].string,
            let price = Money(json: json["price"]),
            let originalPrice = Money(json: json["original_price"]),
            let available = json["available"].bool
            else { return nil }

        self.id = id
        self.size = size
        self.price = price
        self.originalPrice = originalPrice
        self.available = available
        self.stock = json["stock"].int
        self.partner = Article.Partner(json: json["partner"])
    }

    var isDiscounted: Bool {
        return price < originalPrice
    }

}

extension Article.Partner: JSONInitializable {

    init?(json: JSON) {
        guard let id = json["id"].string,
            let name = json["name"].string,
            let detailsURL = json["detail_url"].string
            else { return nil }

        self.id = id
        self.name = name
        self.detailsURL = detailsURL
    }

}
