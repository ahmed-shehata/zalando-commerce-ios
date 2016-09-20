//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

public struct CheckAddressRequest {
    public let address: CheckAddress
    public let pickupPoint: PickupPoint?
}

extension CheckAddressRequest: JSONRepresentable {

    private struct Keys {
        static let address = "address"
        static let pickupPoint = "pickup_point"
    }

    func toJSON() -> [String : AnyObject] {
        var result: [String: AnyObject] = [
            Keys.address: address.toJSON()
        ]
        if let pickupPoint = pickupPoint {
            result[Keys.pickupPoint] = pickupPoint.toJSON()
        }
        return result
    }

}
