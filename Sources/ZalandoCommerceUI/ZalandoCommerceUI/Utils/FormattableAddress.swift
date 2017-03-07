//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import ZalandoCommerceAPI
import Contacts

extension FormattableAddress {

    var formattedContact: String? {
        let contactFormatter = CNContactFormatter()
        let contact = CNMutableContact()

        contact.givenName = firstName
        contact.familyName = lastName

        return contactFormatter.string(from: contact)
    }

    var formattedPostalAddress: String {
        let postalFormatter = CNPostalAddressFormatter()
        let postalAddress = CNMutablePostalAddress()

        postalAddress.city = city
        postalAddress.postalCode = zip
        postalAddress.isoCountryCode = countryCode

        let addressLines = [addressLine1, addressLine2]
        postalAddress.street = addressLines.filter { !$0.isEmpty }.joined(separator: "\n")

        return postalFormatter.string(from: postalAddress)
    }

    var splittedFormattedPostalAddress: [String] {
        let postalFormatter = CNPostalAddressFormatter()
        let firstLineAddress = CNMutablePostalAddress()
        let secondLineAddress = CNMutablePostalAddress()

        if isBillingAllowed {
            firstLineAddress.street = shortAddressLine
            secondLineAddress.city = city
            secondLineAddress.postalCode = zip
            secondLineAddress.isoCountryCode = countryCode
        } else {
            firstLineAddress.street = addressLine1
            secondLineAddress.street = addressLine2
        }

        return [postalFormatter.string(from: firstLineAddress), postalFormatter.string(from: secondLineAddress)]
    }

}
