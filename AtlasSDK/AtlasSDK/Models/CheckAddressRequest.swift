//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

public struct CheckAddressRequest {
    public let address: CheckAddress
    public let pickupPoint: PickupPoint?
}

extension CheckAddressRequest: JSONRepresentable {

    fileprivate struct Keys {
        static let address = "address"
        static let pickupPoint = "pickup_point"
    }

    func toJSON() -> [String : AnyObject] {
        var result: [String: AnyObject] = [
            Keys.address: address.toJSON() as AnyObject
        ]
        if let pickupPoint = pickupPoint {
            result[Keys.pickupPoint] = pickupPoint.toJSON() as AnyObject?
        }
        return result
    }

}
