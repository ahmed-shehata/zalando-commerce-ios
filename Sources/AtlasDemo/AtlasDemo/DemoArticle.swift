//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import ZalandoCommerceAPI
import Freddy

struct DemoArticle {

    enum DataError: Error {
        case incomplete
    }

    struct Brand {
        let key: String
        let name: String
        let logoURL: URL?
        let largeLogoURL: URL?
        let shopURL: URL
    }

    struct Attribute {
        let name: String
        let values: [String]
    }

    struct Unit {
        let id: String
        let size: String
        let price: Price
        let originalPrice: Price
        let available: Bool
        let stock: Int
    }

    struct Price {
        let currency: String
        let valueInCents: Int
        let value: Double
        let formatted: String
    }

    struct Media {
        let images: [Image]
    }

    struct Image {
        let orderNumber: Int
        let type: String
        let thumbnailHDURL: URL
        let smallURL: URL
        let smallHDURL: URL
        let mediumURL: URL
        let mediumHDURL: URL
        let largeURL: URL
        let largeHDURL: URL
    }

    let id: String
    let modelId: String
    let name: String
    let shopURL: URL
    let color: String
    let available: Bool
    let season: String
    let seasonYear: String
    let additionalInfos: [String]
    let genders: [String]
    let ageGroups: [String]
    let brand: Brand
    let categoryKeys: [String]
    let attributes: [Attribute]
    let units: [Unit]
    let media: Media

    var imageThumbURL: URL? {
        guard let img = self.media.images.first else { return nil }
        return img.mediumHDURL
    }

}

extension DemoArticle: JSONDecodable {

    init(json: JSON) throws {
        guard let id = try? json.getString(at: "id"),
            let modelId = try? json.getString(at: "modelId"),
            let name = try? json.getString(at: "name"),
            let shopURL = json.getUrl(at: "shopUrl"),
            let color = try? json.getString(at: "color"),
            let available = try? json.getBool(at: "available"),
            let season = try? json.getString(at: "season"),
            let seasonYear = try? json.getString(at: "seasonYear"),
            let brand = try? json.decode(at: "brand", type: Brand.self),
            let media = try? json.decode(at: "media", type: Media.self)
            else { throw DataError.incomplete }

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

        additionalInfos = try json.getArray(at: "additionalInfos").flatMap { String(describing: $0) }
        genders = try json.getArray(at: "genders").flatMap { String(describing: $0) }
        ageGroups = try json.getArray(at: "ageGroups").flatMap { String(describing: $0) }
        categoryKeys = try json.getArray(at: "categoryKeys").flatMap { String(describing: $0) }
        attributes = try json.getArray(at: "attributes").flatMap { DemoArticle.Attribute(json: $0) }
        units = try json.getArray(at: "units").flatMap { DemoArticle.Unit(json: $0) }
    }
}

extension DemoArticle.Brand: JSONDecodable {

    init(json: JSON) throws {
        guard let key = try? json.getString(at: "key"),
            let name = try? json.getString(at: "name"),
            let shopURL = json.getUrl(at: "shopUrl")
            else { throw DemoArticle.DataError.incomplete }

        self.key = key
        self.name = name
        self.shopURL = shopURL
        self.logoURL = json.getUrl(at: "logoUrl")
        self.largeLogoURL = json.getUrl(at: "logoLargeUrl")
    }

}

extension DemoArticle.Attribute {

    init?(json: JSON) {
        guard let name = try? json.getString(at: "name") else { return nil }
        self.name = name
        let values = (try? json.getArray(at: "values")) ?? []
        self.values = values.flatMap { String(describing: $0) }
    }

}

extension DemoArticle.Unit {

    init?(json: JSON) {
        guard let id = try? json.getString(at: "id"),
            let size = try? json.getString(at: "size"),
            let price = try? json.decode(at: "price", type: DemoArticle.Price.self),
            let originalPrice = try? json.decode(at: "originalPrice", type: DemoArticle.Price.self),
            let available = try? json.getBool(at: "available"),
            let stock = try? json.getInt(at: "stock")
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

extension DemoArticle.Price: JSONDecodable {

    init(json: JSON) throws {
        guard let currency = try? json.getString(at: "currency"),
            let value = try? json.getDouble(at: "value"),
            let formatted = try? json.getString(at: "formatted")
            else { throw DemoArticle.DataError.incomplete }
        self.currency = currency
        self.valueInCents = Int(value * 100)
        self.value = value
        self.formatted = formatted
    }

}

extension DemoArticle.Media: JSONDecodable {

    init(json: JSON) throws {
        self.images = try json.getArray(at: "images").flatMap { DemoArticle.Image(json: $0) }
    }

}

extension DemoArticle.Image {

    init?(json: JSON) {
        guard let orderNumber = try? json.getInt(at: "orderNumber"),
            let type = try? json.getString(at: "type"),
            let thumbnailHDURL = json.getUrl(at: "thumbnailHdUrl"),
            let smallURL = json.getUrl(at: "smallUrl"),
            let smallHDURL = json.getUrl(at: "smallHdUrl"),
            let mediumURL = json.getUrl(at: "mediumUrl"),
            let mediumHDURL = json.getUrl(at: "mediumHdUrl"),
            let largeURL = json.getUrl(at: "largeUrl"),
            let largeHDURL = json.getUrl(at: "largeHdUrl")
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

func == (lhs: DemoArticle.Image, rhs: DemoArticle.Image) -> Bool {
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

func == (lhs: DemoArticle.Price, rhs: DemoArticle.Price) -> Bool {
    return lhs.valueInCents == rhs.valueInCents
}

func < (lhs: DemoArticle.Price, rhs: DemoArticle.Price) -> Bool {
    return lhs.valueInCents < rhs.valueInCents
}

extension JSON {

    func getUrl(at path: String) -> URL? {
        guard let string = try? getString(at: path),
            let url = URL(string: string)
            else { return nil }
        return url
    }

}
