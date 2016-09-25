//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK
import Contacts

extension FormattableAddress {

    internal func fullContactPostalAddress(localizedWith localizer: Localizer) -> String {
        let parts = [formattedContact, formattedPostalAddress(localizedWith: localizer)]
        return parts.flatMap { $0 }.joinWithSeparator(", ")
    }

    internal var formattedContact: String? {
        let contactFormatter = CNContactFormatter()
        let contact = CNMutableContact()

        contact.givenName = firstName
        contact.familyName = lastName

        return contactFormatter.stringFromContact(contact)
    }

    internal func formattedPostalAddress(localizedWith localizer: Localizer) -> String {
        let postalFormatter = CNPostalAddressFormatter()
        let postalAddress = CNMutablePostalAddress()

        postalAddress.city = city
        postalAddress.postalCode = zip
        postalAddress.ISOCountryCode = countryCode

        let addressLines = [prefixedAddressLine1(localizedWith: localizer), prefixedAddressLine2(localizedWith: localizer)]
        postalAddress.street = addressLines.filter { !$0.isEmpty }.joinWithSeparator("\n")

        return postalFormatter.stringFromPostalAddress(postalAddress)
    }

    internal func splittedFormattedPostalAddress(localizedWith localizer: Localizer) -> [String] {
        let postalFormatter = CNPostalAddressFormatter()
        let firstLineAddress = CNMutablePostalAddress()
        let secondLineAddress = CNMutablePostalAddress()

        firstLineAddress.street = prefixedShortAddressLine(localizedWith: localizer)

        secondLineAddress.city = city
        secondLineAddress.postalCode = zip
        secondLineAddress.ISOCountryCode = countryCode

        return [postalFormatter.stringFromPostalAddress(firstLineAddress), postalFormatter.stringFromPostalAddress(secondLineAddress)]
    }

}
