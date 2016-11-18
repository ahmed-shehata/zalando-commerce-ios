//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

public struct UpdateAddressRequest {
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

extension UpdateAddressRequest: JSONRepresentable {

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

    func toJSON() -> [String: AnyObject] {
        var result: [String: AnyObject] = [
            Keys.gender: gender.rawValue as AnyObject,
            Keys.firstName: firstName as AnyObject,
            Keys.lastName: lastName as AnyObject,
            Keys.zip: zip as AnyObject,
            Keys.city: city as AnyObject,
            Keys.countryCode: countryCode as AnyObject,
            Keys.defaultBilling: defaultBilling as AnyObject,
            Keys.defaultShipping: defaultShipping as AnyObject
        ]
        if let street = street {
            result[Keys.street] = street as AnyObject?
        }
        if let additional = additional {
            result[Keys.additional] = additional as AnyObject?
        }
        if let pickupPoint = pickupPoint {
            result[Keys.pickupPoint] = pickupPoint.toJSON() as AnyObject?
        }
        return result
    }
}
