//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

extension StreetAddress {

    internal var isPickupPoint: Bool {
        return pickupPoint != nil
    }

    internal var addressLine1: String {
        return (isPickupPoint ? pickupPoint?.id : street) ?? ""
    }

    internal var addressLine2: String {
        return (isPickupPoint ? pickupPoint?.memberId : additional) ?? ""
    }

    internal var shortAddressLine: String {
        return [addressLine1, addressLine2].filter { !$0.isEmpty }.joinWithSeparator(", ")
    }

    internal var prefixedAddressLine1: String {
        guard isPickupPoint && !addressLine1.isEmpty else { return addressLine1 }
        return UILocalizer.string("Address.prefix.packstation") + ": " + addressLine1
    }

    internal var prefixedAddressLine2: String {
        guard isPickupPoint && !addressLine2.isEmpty else { return addressLine2 }
        return UILocalizer.string("Address.prefix.memberID") + ": " + addressLine2
    }

    internal var prefixedShortAddressLine: String {
        guard isPickupPoint && !shortAddressLine.isEmpty else { return shortAddressLine }
        return UILocalizer.string("Address.prefix.packstation.abbreviation") + ": " + shortAddressLine
    }

}
