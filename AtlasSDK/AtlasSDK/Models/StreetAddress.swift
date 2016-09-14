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

    var addressLine1: String {
        return street ?? pickupPoint?.name ?? ""
    }
    var addressLine2: String {
        return additional ?? pickupPoint?.memberId ?? ""
    }

}
