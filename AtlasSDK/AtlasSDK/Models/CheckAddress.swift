//
//  Copyright © 2016 Zalando SE. All rights reserved.
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

    func toJSON() -> [String : AnyObject] {
        var result: [String: AnyObject] = [
            Keys.zip: zip as AnyObject,
            Keys.city: city as AnyObject,
            Keys.countryCode: countryCode as AnyObject
        ]
        if let street = street {
            result[Keys.street] = street as AnyObject?
        }
        if let additional = additional {
            result[Keys.additional] = additional as AnyObject?
        }
        return result
    }

}
