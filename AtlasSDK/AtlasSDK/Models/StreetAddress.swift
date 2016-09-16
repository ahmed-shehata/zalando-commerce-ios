//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public protocol StreetAddress {
    var street: String? { get }
    var additional: String? { get }
    var pickupPoint: PickupPoint? { get }
}
