//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK
import SwiftyJSON

public struct DemoArticle {

    public struct Brand {
        public let key: String
        public let name: String
        public let logoURL: URL?
        public let largeLogoURL: URL?
        public let shopURL: URL
    }

    public struct Attribute {
        public let name: String
        public let values: [String]
    }

    public struct Unit {
        public let id: String
        public let size: String
        public let price: Price
        public let originalPrice: Price
        public let available: Bool
        public let stock: Int
    }

    public struct Price {
        public let currency: String
        public let valueInCents: Int
        public let value: Float
        public let formatted: String
    }

    public struct Media {
        public let images: [Image]
    }

    public struct Image {
        public let orderNumber: Int
        public let type: String
        public let thumbnailHDURL: URL
        public let smallURL: URL
        public let smallHDURL: URL
        public let mediumURL: URL
        public let mediumHDURL: URL
        public let largeURL: URL
        public let largeHDURL: URL
    }

    public let id: String
    public let modelId: String
    public let name: String
    public let shopURL: URL
    public let color: String
    public let available: Bool
    public let season: String
    public let seasonYear: String
    public let additionalInfos: [String]
    public let genders: [String]
    public let ageGroups: [String]
    public let brand: Brand
    public let categoryKeys: [String]
    public let attributes: [Attribute]
    public let units: [Unit]
    public let media: Media

    public var imageThumbURL: URL? {
        guard let img = self.media.images.first else { return nil }
        return img.mediumHDURL
    }

}

extension DemoArticle {

    init?(json: JSON) {
        guard let id = json["id"].string,
            let modelId = json["modelId"].string,
            let name = json["name"].string,
            let shopURL = json["shopUrl"].URL,
            let color = json["color"].string,
            let available = json["available"].bool,
            let season = json["season"].string,
            let seasonYear = json["seasonYear"].string,
            let brand = Brand(json: json["brand"]),
            let media = Media(json: json["media"])
            else { return nil }

        self.id = id
        self.modelId = modelId
        self.name = name
        self.shopURL = shopURL
        self.color = color
        self.available = available
        self.season = season
        self.seasonYear = seasonYear
        self.brand = brand
        self.media = media

        additionalInfos = json["additionalInfos"].arrayValue.flatMap { $0.string }
        genders = json["genders"].arrayValue.flatMap { $0.string }
        ageGroups = json["ageGroups"].arrayValue.flatMap { $0.string }
        categoryKeys = json["categoryKeys"].arrayValue.flatMap { $0.string }
        attributes = json["attributes"].arrayValue.flatMap { DemoArticle.Attribute(json: $0) }
        units = json["units"].arrayValue.flatMap { DemoArticle.Unit(json: $0) }
    }
}

extension DemoArticle.Brand {

    init?(json: JSON) {
        guard let key = json["key"].string,
            let name = json["name"].string,
            let shopURL = json["shopUrl"].URL
            else { return nil }

        self.key = key
        self.name = name
        self.shopURL = shopURL
        self.logoURL = json["logoUrl"].URL
        self.largeLogoURL = json["logoLargeUrl"].URL
    }

}

extension DemoArticle.Attribute {

    init?(json: JSON) {
        guard let name = json["name"].string else { return nil }
        self.name = name
        self.values = json["values"].arrayValue.flatMap { $0.string }
    }

}

extension DemoArticle.Unit {

    init?(json: JSON) {
        guard let id = json["id"].string,
            let size = json["size"].string,
            let price = DemoArticle.Price(json: json["price"]),
            let originalPrice = DemoArticle.Price(json: json["originalPrice"]),
            let available = json["available"].bool,
            let stock = json["stock"].int
            else { return nil }

        self.id = id
        self.size = size
        self.price = price
        self.originalPrice = originalPrice
        self.stock = stock
        self.available = available
    }

    var isDiscounted: Bool {
        return price < originalPrice
    }

}

extension DemoArticle.Price {

    init?(json: JSON) {
        guard let currency = json["currency"].string,
            let value = json["value"].float,
            let formatted = json["formatted"].string else { return nil }
        self.currency = currency
        self.valueInCents = Int(value * 100)
        self.value = value
        self.formatted = formatted
    }

}

extension DemoArticle.Media {

    init?(json: JSON) {
        self.images = json["images"].arrayValue.flatMap { DemoArticle.Image(json: $0) }
    }

}

extension DemoArticle.Image {

    init?(json: JSON) {
        guard let orderNumber = json["orderNumber"].int,
            let type = json["type"].string,
            let thumbnailHDURL = json["thumbnailHdUrl"].URL,
            let smallURL = json["smallUrl"].URL,
            let smallHDURL = json["smallHdUrl"].URL,
            let mediumURL = json["mediumUrl"].URL,
            let mediumHDURL = json["mediumHdUrl"].URL,
            let largeURL = json["largeUrl"].URL,
            let largeHDURL = json["largeHdUrl"].URL
            else { return nil }

        self.orderNumber = orderNumber
        self.type = type
        self.thumbnailHDURL = thumbnailHDURL
        self.smallURL = smallURL
        self.smallHDURL = smallHDURL
        self.mediumURL = mediumURL
        self.mediumHDURL = mediumHDURL
        self.largeURL = largeURL
        self.largeHDURL = largeHDURL
    }

}

extension DemoArticle.Image: Equatable { }

public func == (lhs: DemoArticle.Image, rhs: DemoArticle.Image) -> Bool {
    return lhs.type == rhs.type
}

extension DemoArticle {

    var imageURLs: [URL] {
        return media.images
            .filter { $0.orderNumber >= 1 && $0.orderNumber <= 10 }
            .flatMap { $0.largeURL }
    }

    var availableSizes: [String] {
        return units.filter { $0.available }.map { $0.size }
    }

}

extension DemoArticle.Price: Comparable { }

public func == (lhs: DemoArticle.Price, rhs: DemoArticle.Price) -> Bool {
    return lhs.valueInCents == rhs.valueInCents
}

public func < (lhs: DemoArticle.Price, rhs: DemoArticle.Price) -> Bool {
    return lhs.valueInCents < rhs.valueInCents
}
