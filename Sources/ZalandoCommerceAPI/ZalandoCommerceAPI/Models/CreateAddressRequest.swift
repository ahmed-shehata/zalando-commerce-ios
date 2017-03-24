//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct CreateAddressRequest {

    public let gender: Gender
    public let firstName: String
    public let lastName: String
    public let street: String?
    public let additional: String?
    public let zip: String
    public let city: String
    public let countryCode: String
    public let pickupPoint: PickupPoint?
    public let defaultBilling: Bool
    public let defaultShipping: Bool

}

extension CreateAddressRequest: JSONRepresentable {

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
        static let defaultBilling = "default_billing"
        static let defaultShipping = "default_shipping"
    }

    func toJSON() -> JSONDictionary {
        var result: [String: Any] = [
            Keys.gender: gender.rawValue,
            Keys.firstName: firstName,
            Keys.lastName: lastName,
            Keys.zip: zip,
            Keys.city: city,
            Keys.countryCode: countryCode,
            Keys.defaultBilling: defaultBilling,
            Keys.defaultShipping: defaultShipping
        ]
        if let street = street {
            result[Keys.street] = street
        }
        if let additional = additional {
            result[Keys.additional] = additional
        }
        if let pickupPoint = pickupPoint {
            result[Keys.pickupPoint] = pickupPoint.toJSON()
        }
        return result
    }

}
