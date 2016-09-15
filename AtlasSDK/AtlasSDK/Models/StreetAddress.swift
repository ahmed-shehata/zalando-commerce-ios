//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public protocol StreetAddress {
    var street: String? { get }
    var additional: String? { get }
    var pickupPoint: PickupPoint? { get }
}

extension StreetAddress {

    public var isPickupPoint: Bool {
        return pickupPoint != nil
    }

    public var addressLine1: String {
        return (isPickupPoint ? pickupPoint?.id : street) ?? ""
    }

    public var addressLine2: String {
        return (isPickupPoint ? pickupPoint?.memberId : additional) ?? ""
    }

    public var shortAddressLine: String {
        return [addressLine1, addressLine2].filter { !$0.isEmpty }.joinWithSeparator(", ")
    }

}
