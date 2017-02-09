//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

public struct PickupPoint {

    public let id: String
    public let name: String
    public let memberId: String?

}

public enum PickupPointType {

    case packstation
    case pickupPoint(name: String)

    init(name: String) {
        self = name == "PACKSTATION" ? .packstation : .pickupPoint(name: name)
    }

    var localizedKey: String {
        switch self {
        case .packstation:
        case .pickupPoint(let name):
        }
    }

}

extension PickupPoint: Hashable {

    public var hashValue: Int {
        return id.hashValue
    }

}

public func == (lhs: PickupPoint, rhs: PickupPoint) -> Bool {
    return lhs.id == rhs.id
}

extension PickupPoint {

    fileprivate struct Keys {
        static let id = "id"
        static let name = "name"
        static let memberId = "member_id"
    }

}

extension PickupPoint: JSONInitializable {

    init?(json: JSON) {
        guard let id = json[Keys.id].string,
            let name = json[Keys.name].string
            else { return nil }

        let memberId = json[Keys.memberId].string
        self.init(id: id, name: name, memberId: memberId)
    }

}

extension PickupPoint: JSONRepresentable {

    func toJSON() -> JSONDictionary {
        var result: [String: Any] = [
            Keys.id: id,
            Keys.name: name
        ]
        if let memberId = memberId {
            result[Keys.memberId] = memberId
        }
        return result
    }

}
