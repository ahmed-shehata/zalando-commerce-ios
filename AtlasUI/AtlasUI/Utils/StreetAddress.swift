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

    internal func prefixedAddressLine1(localizedWith localizer: LocalizerProviderType) -> String {
        guard isPickupPoint && !addressLine1.isEmpty else { return addressLine1 }
        return localizer.loc("Address.prefix.packstation") + ": " + addressLine1
    }

    internal func prefixedAddressLine2(localizedWith localizer: LocalizerProviderType) -> String {
        guard isPickupPoint && !addressLine2.isEmpty else { return addressLine2 }
        return localizer.loc("Address.prefix.memberID") + ": " + addressLine2
    }

    internal func prefixedShortAddressLine(localizedWith localizer: LocalizerProviderType) -> String {
        guard isPickupPoint && !shortAddressLine.isEmpty else { return shortAddressLine }
        return localizer.loc("Address.prefix.packstation.abbreviation") + ": " + shortAddressLine
    }

}
