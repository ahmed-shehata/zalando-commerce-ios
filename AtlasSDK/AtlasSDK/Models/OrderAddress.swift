//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct OrderAddress: FormattableAddress {
    public let gender: Gender
    public let firstName: String
    public let lastName: String
    public let street: String?
    public let additional: String?
    public let zip: String
    public let city: String
    public let countryCode: String
    public let pickupPoint: PickupPoint?
}

extension OrderAddress: JSONInitializable {

    fileprivate struct Keys {
        static let gender = "gender"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let street = "street"
        static let additional = "additional"
        static let zip = "zip"
        static let city = "city"
        static let countryCode = "country_code"
        static let pickupPoint = "pickup_point"
    }

    init?(json: JSON) {
        guard let genderRaw = json[Keys.gender].string,
            let gender = Gender(rawValue: genderRaw),
            let firstName = json[Keys.firstName].string,
            let lastName = json[Keys.lastName].string,
            let zip = json[Keys.zip].string,
            let city = json[Keys.city].string,
            let countryCode = json[Keys.countryCode].string
            else { return nil }

        self.init(gender: gender,
                  firstName: firstName,
                  lastName: lastName,
                  street: json[Keys.street].string,
                  additional: json[Keys.additional].string,
                  zip: zip,
                  city: city,
                  countryCode: countryCode,
                  pickupPoint: PickupPoint(json: json[Keys.pickupPoint]))
    }
}
