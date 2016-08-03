//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

public struct DemoArticle {

    public struct Brand {
        public let key: String
        public let name: String
        public let logoURL: NSURL?
        public let largeLogoURL: NSURL?
        public let shopURL: NSURL
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
        public let thumbnailHDURL: NSURL
        public let smallURL: NSURL
        public let smallHDURL: NSURL
        public let mediumURL: NSURL
        public let mediumHDURL: NSURL
        public let largeURL: NSURL
        public let largeHDURL: NSURL
    }

    public let id: String
    public let modelId: String
    public let name: String
    public let shopURL: NSURL
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

    public var imageThumbURL: NSURL? {
        guard let img = self.media.images.first else { return nil }
        return img.mediumHDURL
    }

}

extension DemoArticle {

    init?(json: JSON) {
        guard let
        id = json["id"].string,
            modelId = json["modelId"].string,
            name = json["name"].string,
            shopURL = json["shopUrl"].URL,
            color = json["color"].string,
            available = json["available"].bool,
            season = json["season"].string,
            seasonYear = json["seasonYear"].string,
            brand = Brand(json: json["brand"]),
            media = Media(json: json["media"])
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
        units = json["units"].arrayValue.flatMap { DemoArticle.Unit(json: $0) }.sort()
    }
}

extension DemoArticle.Brand {

    init?(json: JSON) {
        guard let
        key = json["key"].string,
            name = json["name"].string,
            shopURL = json["shopUrl"].URL else { return nil }
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
        guard let
        id = json["id"].string,
            size = json["size"].string,
            price = DemoArticle.Price(json: json["price"]),
            originalPrice = DemoArticle.Price(json: json["originalPrice"]),
            available = json["available"].bool,
            stock = json["stock"].int else { return nil }

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
        guard let
        currency = json["currency"].string,
            value = json["value"].float,
            formatted = json["formatted"].string else { return nil }
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
        guard let
        orderNumber = json["orderNumber"].int,
            type = json["type"].string,
            thumbnailHDURL = json["thumbnailHdUrl"].URL,
            smallURL = json["smallUrl"].URL,
            smallHDURL = json["smallHdUrl"].URL,
            mediumURL = json["mediumUrl"].URL,
            mediumHDURL = json["mediumHdUrl"].URL,
            largeURL = json["largeUrl"].URL,
            largeHDURL = json["largeHdUrl"].URL else { return nil }
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

    var imageURLs: [NSURL] {
        return media.images
            .filter { $0.orderNumber >= 1 && $0.orderNumber <= 10 }
            .flatMap { $0.largeURL }
    }

    var availableSizes: [String] {
        return units.filter { $0.available }.map { $0.size }.sort { first, second in
            guard let firstValue = sizeMap[first], secondValue = sizeMap[second] else {
                return first <= second
            }
            return firstValue <= secondValue
        }
    }

}

extension DemoArticle.Price: Comparable { }

public func == (lhs: DemoArticle.Price, rhs: DemoArticle.Price) -> Bool {
    return lhs.valueInCents == rhs.valueInCents
}

public func < (lhs: DemoArticle.Price, rhs: DemoArticle.Price) -> Bool {
    return lhs.valueInCents < rhs.valueInCents
}

extension DemoArticle.Unit: Comparable { }

public func == (lhs: DemoArticle.Unit, rhs: DemoArticle.Unit) -> Bool {
    return lhs.id == rhs.id
}

public func < (lhs: DemoArticle.Unit, rhs: DemoArticle.Unit) -> Bool {
    guard let lhsSizeWeight = sizeMap[lhs.size], rhsSizeWeight = sizeMap[rhs.size] else {
        return lhs.size < rhs.size
    }
    return lhsSizeWeight < rhsSizeWeight
}
