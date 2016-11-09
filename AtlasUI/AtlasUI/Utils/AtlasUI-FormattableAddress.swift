//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK
import Contacts

extension FormattableAddress {

    var formattedContact: String? {
        let contactFormatter = CNContactFormatter()
        let contact = CNMutableContact()

        contact.givenName = firstName
        contact.familyName = lastName

        return contactFormatter.stringFromContact(contact)
    }

    var formattedPostalAddress: String {
        let postalFormatter = CNPostalAddressFormatter()
        let postalAddress = CNMutablePostalAddress()

        postalAddress.city = city
        postalAddress.postalCode = zip
        postalAddress.ISOCountryCode = countryCode

        let addressLines = [prefixedAddressLine1, prefixedAddressLine2]
        postalAddress.street = addressLines.filter { !$0.isEmpty }.joinWithSeparator("\n")

        return postalFormatter.stringFromPostalAddress(postalAddress)
    }

    var splittedFormattedPostalAddress: [String] {
        let postalFormatter = CNPostalAddressFormatter()
        let firstLineAddress = CNMutablePostalAddress()
        let secondLineAddress = CNMutablePostalAddress()

        firstLineAddress.street = prefixedShortAddressLine

        secondLineAddress.city = city
        secondLineAddress.postalCode = zip
        secondLineAddress.ISOCountryCode = countryCode

        return [postalFormatter.stringFromPostalAddress(firstLineAddress), postalFormatter.stringFromPostalAddress(secondLineAddress)]
    }

}
