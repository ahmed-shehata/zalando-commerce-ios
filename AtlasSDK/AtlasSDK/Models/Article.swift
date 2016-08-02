//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasCommons

/**
 Represents a single article
 */
public struct Article {

    public let id: String
    public let name: String
    public let brand: Brand
    public let units: [Unit]
    public let media: Media

    public var hasSingleUnit: Bool {
        return units.count == 1
    }

    public struct Brand {
        public let name: String
    }

    public struct Unit {
        public let id: String
        public let size: String
        public let price: Price
        public let originalPrice: Price
        public let available: Bool
        public let stock: Int
        public let partner: Partner?
    }

    public struct Media {
        public let images: [Image]
    }

    public struct Image {
        public let order: Int
        public let catalogUrl: NSURL
        public let catalogHDUrl: NSURL
        public let detailUrl: NSURL
        public let detailHDUrl: NSURL
        public let largeUrl: NSURL
        public let largeHDUrl: NSURL
    }

    /**
     Represents a price of `Article`
     */
    public struct Price {
        public let currency: String
        public let amount: Float
    }

    public struct Partner {
        public let id: String
        public let name: String
        public let detailsURL: String
    }
}

extension Article: JSONInitializable {

    init?(json: JSON) {
        guard let
        id = json["id"].string,
            name = json["name"].string,
            brand = Brand(json: json["brand"]),
            media = Media(json: json["media"])
        else { return nil }

        self.id = id
        self.name = name
        self.media = media
        self.brand = brand
        self.units = json["units"].arrayValue.flatMap { Article.Unit(json: $0) }
    }

}

extension Article.Unit: JSONInitializable {

    init?(json: JSON) {
        guard let
        id = json["id"].string,
            size = json["size"].string,
            price = Article.Price(json: json["price"]),
            originalPrice = Article.Price(json: json["original_price"]),
            available = json["available"].bool,
            stock = json["stock"].int
        else {
            return nil
        }

        self.id = id
        self.size = size
        self.price = price
        self.originalPrice = originalPrice
        self.stock = stock
        self.available = available

        self.partner = Article.Partner(json: json["partner"])
    }

    var isDiscounted: Bool {
        return price < originalPrice
    }

}

extension Article.Brand: JSONInitializable {
    init?(json: JSON) {
        guard let name = json["name"].string else { return nil }

        self.name = name
    }
}

extension Article.Media: JSONInitializable {

    init?(json: JSON) {
        self.images = json["images"].arrayValue.flatMap { Article.Image(json: $0) }
    }

}

extension Article.Image: JSONInitializable {

    init?(json: JSON) {
        guard let
        order = json["order"].int,
            catalogUrl = json["catalog"].URL,
            catalogHDUrl = json["catalog_hd"].URL,
            detailUrl = json["detail"].URL,
            detailHDUrl = json["detail_hd"].URL,
            largeUrl = json["large"].URL,
            largeHDUrl = json["large_hd"].URL
        else { return nil }
        self.order = order
        self.catalogUrl = catalogUrl
        self.catalogHDUrl = catalogHDUrl
        self.detailUrl = detailUrl
        self.detailHDUrl = detailHDUrl
        self.largeUrl = largeUrl
        self.largeHDUrl = largeHDUrl
    }

}

extension Article.Price: JSONInitializable {
    init?(json: JSON) {
        guard let
        currency = json["currency"].string,
            amount = json["amount"].float
        else { return nil }
        self.currency = currency
        self.amount = amount
    }

}

extension Article.Partner: JSONInitializable {
    init?(json: JSON) {
        guard let
        id = json["id"].string,
            name = json["name"].string,
            detailsURL = json["detail_url"].string
        else { return nil }

        self.id = id
        self.name = name
        self.detailsURL = detailsURL
    }

}

extension Article.Price: Comparable { }

public func == (lhs: Article.Price, rhs: Article.Price) -> Bool {
    return lhs.amount == rhs.amount
}

public func < (lhs: Article.Price, rhs: Article.Price) -> Bool {
    return lhs.amount < rhs.amount
}
