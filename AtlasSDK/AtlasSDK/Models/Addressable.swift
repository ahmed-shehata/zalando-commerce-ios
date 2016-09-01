//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Contacts

public protocol Addressable {

    var gender: Gender { get }
    var firstName: String { get }
    var lastName: String { get }
    var street: String? { get }
    var additional: String? { get }
    var zip: String { get }
    var city: String { get }
    var countryCode: String { get }

}

public func == (lhs: Addressable, rhs: Addressable) -> Bool {
    return lhs.formattedAddress == rhs.formattedAddress
}

extension Addressable {

    public var fullAddress: String {
        let parts = [formattedContact, formattedAddress]
        return parts.flatMap({ $0 }).joinWithSeparator(", ")
    }

    public var formattedContact: String? {
        let contactFormatter = CNContactFormatter()
        let contact = CNMutableContact()

        contact.givenName = self.firstName
        contact.familyName = self.lastName

        return contactFormatter.stringFromContact(contact)
    }

    public var formattedAddress: String {
        let postalFormatter = CNPostalAddressFormatter()
        let postalAddress = CNMutablePostalAddress()

        postalAddress.city = self.city
        postalAddress.postalCode = self.zip
        postalAddress.ISOCountryCode = self.countryCode

        if let street = self.street {
            postalAddress.street = street
        }

        if let additional = self.additional {
            postalAddress.state = additional
        }

        return postalFormatter.stringFromPostalAddress(postalAddress)
    }

}
