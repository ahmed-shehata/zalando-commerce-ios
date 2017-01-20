//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

public struct CheckAddress {
    public let street: String?
    public let additional: String?
    public let zip: String
    public let city: String
    public let countryCode: String
}

extension CheckAddress: JSONInitializable {

    fileprivate struct Keys {
        static let street = "street"
        static let additional = "additional"
        static let zip = "zip"
        static let city = "city"
        static let countryCode = "country_code"
    }

    init?(json: JSON) {
        guard let zip = json[Keys.zip].string,
            let city = json[Keys.city].string,
            let countryCode = json[Keys.countryCode].string
            else { return nil }

        self.init(street: json[Keys.street].string,
                  additional: json[Keys.additional].string,
                  zip: zip,
                  city: city,
                  countryCode: countryCode)
    }
}

extension CheckAddress: JSONRepresentable {

    func toJSON() -> [String : Any] {
        var result: [String: Any] = [
            Keys.zip: zip,
            Keys.city: city,
            Keys.countryCode: countryCode
        ]
        if let street = street {
            result[Keys.street] = street
        }
        if let additional = additional {
            result[Keys.additional] = additional
        }
        return result
    }

}

public func === (lhs: CheckAddress?, rhs: CheckAddress?) -> Bool {
    guard let lhs = lhs, let rhs = rhs else { return false }

    return lhs.street == rhs.street
        && lhs.additional == rhs.additional
        && lhs.zip == rhs.zip
        && lhs.city == rhs.city
        && lhs.countryCode == rhs.countryCode
}
