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

extension Addressable {

    public func fullAddress() -> String {
        let parts = [formatContact(), formatAddress()]
        return parts.flatMap({ $0 }).joinWithSeparator(", ")
    }

    public func formatContact() -> String? {
        let contactFormatter = CNContactFormatter()
        let contact = CNMutableContact()

        contact.givenName = self.firstName
        contact.familyName = self.lastName

        return contactFormatter.stringFromContact(contact)
    }

    public func formatAddress() -> String {
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
