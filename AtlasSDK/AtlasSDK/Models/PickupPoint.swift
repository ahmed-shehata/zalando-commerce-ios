//
//  Copyright © 2016 Zalando SE. All rights reserved.
//


public struct PickupPoint {
    public let id: String
    public let name: String
    public let memberId: String
}

extension PickupPoint: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
}

public func == (lhs: PickupPoint, rhs: PickupPoint) -> Bool {
    return lhs.id == rhs.id
}

extension PickupPoint: JSONInitializable {

    private struct Keys {
        static let id = "id"
        static let name = "name"
        static let memberId = "member_id"
    }

    init?(json: JSON) {
        guard let
        id = json[Keys.id].string,
            name = json[Keys.name].string,
            memberId = json[Keys.memberId].string else { return nil }
        self.init(id: id, name: name, memberId: memberId)
    }
}
