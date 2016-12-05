//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

extension StreetAddress {

    var isPickupPoint: Bool {
        return pickupPoint != nil
    }

    var addressLine1: String {
        return (isPickupPoint ? pickupPoint?.id : street) ?? ""
    }

    var addressLine2: String {
        return (isPickupPoint ? pickupPoint?.memberId : additional) ?? ""
    }

    var shortAddressLine: String {
        return [addressLine1, addressLine2].filter { !$0.isEmpty }.joined(separator: ", ")
    }

    var prefixedAddressLine1: String {
        guard isPickupPoint && !addressLine1.isEmpty else { return addressLine1 }
        return Localizer.format(string: "addressListView.prefix.packstation") + ": " + addressLine1
    }

    var prefixedAddressLine2: String {
        guard isPickupPoint && !addressLine2.isEmpty else { return addressLine2 }
        return Localizer.format(string: "addressListView.prefix.memberID") + ": " + addressLine2
    }

    var prefixedShortAddressLine: String {
        guard isPickupPoint && !shortAddressLine.isEmpty else { return shortAddressLine }
        return Localizer.format(string: "summaryView.label.address.packstationAbbreviation") + ": " + shortAddressLine
    }

}
