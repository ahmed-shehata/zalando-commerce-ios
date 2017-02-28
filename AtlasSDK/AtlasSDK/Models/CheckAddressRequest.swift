//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct CheckAddressRequest {

    public let address: AddressCheck
    public let pickupPoint: PickupPoint?

}

extension CheckAddressRequest: JSONRepresentable {

    fileprivate struct Keys {
        static let address = "address"
        static let pickupPoint = "pickup_point"
    }

    func toJSON() -> [String: Any] {
        var result: [String: Any] = [
            Keys.address: address.toJSON()
        ]
        if let pickupPoint = pickupPoint {
            result[Keys.pickupPoint] = pickupPoint.toJSON()
        }
        return result
    }

}
