//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct BillingAddress: Addressable {

    public let gender: Gender
    public let firstName: String
    public let lastName: String
    public let street: String?
    public let additional: String?
    public let zip: String
    public let city: String
    public let countryCode: String

}

extension BillingAddress: JSONInitializable {

    private struct Keys {
        static let gender = "gender"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let street = "street"
        static let additional = "additional"
        static let zip = "zip"
        static let city = "city"
        static let countryCode = "country_code"
    }

    init?(json: JSON) {
        guard let
        genderRaw = json[Keys.gender].string,
            gender = Gender(rawValue: genderRaw),
            firstName = json[Keys.firstName].string,
            lastName = json[Keys.lastName].string,
            street = json[Keys.street].string,
            zip = json[Keys.zip].string,
            city = json[Keys.city].string,
            countryCode = json[Keys.countryCode].string else { return nil }
        self.init(gender: gender,
            firstName: firstName,
            lastName: lastName,
            street: street,
            additional: json[Keys.additional].string,
            zip: zip,
            city: city,
            countryCode: countryCode)
    }
}
