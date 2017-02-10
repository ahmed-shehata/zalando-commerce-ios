//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

// swiftlint:disable missing_docs

import Foundation

public protocol StreetAddress {

    var street: String? { get }
    var additional: String? { get }
    var pickupPoint: PickupPoint? { get }

}

extension StreetAddress {

    public var isBillingAllowed: Bool {
        return pickupPoint == nil
    }

}
