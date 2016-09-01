//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct Address: Addressable, Equatable {
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

public func == (lhs: Address, rhs: Address) -> Bool {
    return lhs.id == rhs.id
}

extension Address: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }

}
extension Address: JSONInitializable {

    private struct Keys {

        static let id = "id"
        static let customerNumber = "customer_number"
        static let gender = "gender"
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
        guard let
        id = json[Keys.id].string,
            customerNumber = json[Keys.customerNumber].string,
            genderRaw = json[Keys.gender].string,
            gender = Gender(rawValue: genderRaw),
            firstName = json[Keys.firstName].string,
            lastName = json[Keys.lastName].string,
            zip = json[Keys.zip].string,
            city = json[Keys.city].string,
            countryCode = json[Keys.countryCode].string,
            isDefaultBilling = json[Keys.defaultBilling].bool,
            isDefaultShipping = json[Keys.defaultShipping].bool else { return nil }

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
