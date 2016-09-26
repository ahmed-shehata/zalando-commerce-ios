//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

public enum CheckAddressStatus: String {
    case correct = "CORRECT"
    case normalized = "NORMALIZED"
    case notCorrect = "NOT_CORRECT"
}

public struct CheckAddressResponse {
    public let status: CheckAddressStatus
    public let normalizedAddress: CheckAddress
}

extension CheckAddressResponse: JSONInitializable {

    private struct Keys {
        static let status = "status"
        static let normalizedAddress = "normalized_address"
    }

    init?(json: JSON) {
        guard let
            statusRaw = json[Keys.status].string,
            status = CheckAddressStatus(rawValue: statusRaw),
            normalizedAddress = CheckAddress(json: json[Keys.normalizedAddress]) else { return nil }

        self.init(status: status,
                  normalizedAddress: normalizedAddress)
    }

}