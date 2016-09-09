//
// Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Contacts

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

extension FormattableAddress {

    public var fullContactPostalAddress: String {
        let parts = [formattedContact, formattedPostalAddress]
        return parts.flatMap({ $0 }).joinWithSeparator(", ")
    }

    public var formattedContact: String? {
        let contactFormatter = CNContactFormatter()
        let contact = CNMutableContact()

        contact.givenName = self.firstName
        contact.familyName = self.lastName

        return contactFormatter.stringFromContact(contact)
    }

    public var formattedPostalAddress: String {
        let postalFormatter = CNPostalAddressFormatter()
        let postalAddress = CNMutablePostalAddress()

        postalAddress.city = self.city
        postalAddress.postalCode = self.zip
        postalAddress.ISOCountryCode = self.countryCode

        postalAddress.street = addressLine1
        postalAddress.state = addressLine2

        return postalFormatter.stringFromPostalAddress(postalAddress)
    }

    public var splittedPostalAddress: [String] {
        let postalFormatter = CNPostalAddressFormatter()
        let firstLineAddress = CNMutablePostalAddress()
        let secondLineAddress = CNMutablePostalAddress()

        firstLineAddress.street = addressLine1

        secondLineAddress.city = self.city
        secondLineAddress.postalCode = self.zip
        secondLineAddress.ISOCountryCode = self.countryCode
        secondLineAddress.state = addressLine2

        return [postalFormatter.stringFromPostalAddress(firstLineAddress), postalFormatter.stringFromPostalAddress(secondLineAddress)]
    }

}
