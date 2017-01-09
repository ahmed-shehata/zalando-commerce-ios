//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

public protocol FormattableAddress: StreetAddress {

    var gender: Gender { get }
    var firstName: String { get }
    var lastName: String { get }

    var zip: String { get }
    var city: String { get }
    var countryCode: String { get }

}

public protocol EquatableAddress: FormattableAddress {

    var id: String { get }

}

public func == (lhs: EquatableAddress, rhs: EquatableAddress) -> Bool {
    return lhs.id == rhs.id
}

public func === (lhs: EquatableAddress, rhs: EquatableAddress) -> Bool {
    return lhs.id == rhs.id
        && lhs.gender == rhs.gender
        && lhs.firstName == rhs.firstName
        && lhs.lastName == rhs.lastName
        && lhs.zip == rhs.zip
        && lhs.city == rhs.city
        && lhs.countryCode == rhs.countryCode
        && lhs.street == rhs.street
        && lhs.additional == rhs.additional
        && lhs.pickupPoint == rhs.pickupPoint
}
