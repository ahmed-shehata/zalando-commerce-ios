//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct UserAddress: EquatableAddress {

    public let id: String
    public let customerNumber: String
    public let gender: Gender
    public let firstName: String
    public let lastName: String
    public let street: String?

    public let additional: String?
    public let zip: String
    public let city: String
    public let countryCode: String

    public let pickupPoint: PickupPoint?
    public let isDefaultBilling: Bool
    public let isDefaultShipping: Bool
}

extension UserAddress: JSONInitializable {

    fileprivate struct Keys {

        static let id = "id"
        static let gender = "gender"
        static let customerNumber = "customer_number"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let street = "street"
        static let additional = "additional"
        static let zip = "zip"
        static let city = "city"
        static let countryCode = "country_code"
        static let pickupPoint = "pickup_point"
        static let defaultBilling = "default_billing"
        static let defaultShipping = "default_shipping"

    }

    init?(json: JSON) {
        guard let id = json[Keys.id].string,
            let genderRaw = json[Keys.gender].string,
            let customerNumber = json[Keys.customerNumber].string,
            let gender = Gender(rawValue: genderRaw),
            let firstName = json[Keys.firstName].string,
            let lastName = json[Keys.lastName].string,
            let zip = json[Keys.zip].string,
            let city = json[Keys.city].string,
            let countryCode = json[Keys.countryCode].string,
            let isDefaultBilling = json[Keys.defaultBilling].bool,
            let isDefaultShipping = json[Keys.defaultShipping].bool
            else { return nil }

        self.init(id: id,
                  customerNumber: customerNumber,
                  gender: gender,
                  firstName: firstName,
                  lastName: lastName,
                  street: json[Keys.street].string,
                  additional: json[Keys.additional].string,
                  zip: zip,
                  city: city,
                  countryCode: countryCode,
                  pickupPoint: PickupPoint(json: json[Keys.pickupPoint]),
                  isDefaultBilling: isDefaultBilling,
                  isDefaultShipping: isDefaultShipping)
    }
}
