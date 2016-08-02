//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasCommons

/**
 Represents Zalando Customer model
 */
public struct Customer {

    public let customerNumber: String
    public let gender: Gender
    public let firstName: String
    public let lastName: String
    public let email: String

    public enum Gender: String, CustomStringConvertible {
        case Male = "MALE", Female = "FEMALE"

        public var description: String {
            return rawValue
        }
    }

}

extension Customer: JSONInitializable {

    init?(json: JSON) {
        guard let
        customerNumber = json["customer_number"].string,
            gender = json["gender"].string,
            firstName = json["first_name"].string,
            lastName = json["last_name"].string,
            email = json["email"].string
        else { return nil }

        self.customerNumber = customerNumber
        self.gender = Gender(rawValue: gender) ?? Gender.Female // default value in Zalando registration
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }

}

extension Customer: CustomStringConvertible {

    public var description: String {
        return "Customer: { customer_numer: \(self.customerNumber)"
            + ", gender: \(self.gender)"
            + ", first_name: \(self.firstName)"
            + ", last_name: \(self.lastName)"
            + ", email: \(self.email)"
            + " }"
    }

}
