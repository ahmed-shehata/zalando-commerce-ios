//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct GuestAddressRequest {

    public let gender: Gender
    public let firstName: String
    public let lastName: String
    public let street: String?
    public let additional: String?
    public let zip: String
    public let city: String
    public let countryCode: String
    public let pickupPoint: PickupPoint?

    public init(address: FormattableAddress) {
        self.gender = address.gender
        self.firstName = address.firstName
        self.lastName = address.lastName
        self.street = address.street
        self.additional = address.additional
        self.zip = address.zip
        self.city = address.city
        self.countryCode = address.countryCode
        self.pickupPoint = address.pickupPoint
    }

}

extension GuestAddressRequest: JSONRepresentable {

    private struct Keys {
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

    func toJSON() -> JSONDictionary {
        var json: [String: Any] = [
            Keys.gender: gender.rawValue,
            Keys.firstName: firstName,
            Keys.lastName: lastName,
            Keys.zip: zip,
            Keys.city: city,
            Keys.countryCode: countryCode
        ]
        json[Keys.street] = street
        json[Keys.additional] = additional
        json[Keys.pickupPoint] = pickupPoint?.toJSON()
        return json
    }

}
