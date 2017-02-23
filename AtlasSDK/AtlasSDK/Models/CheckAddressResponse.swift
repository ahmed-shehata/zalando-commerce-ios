//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//


import Foundation

public enum CheckAddressStatus: String {

    case correct = "CORRECT"
    case normalized = "NORMALIZED"
    case notCorrect = "NOT_CORRECT"

}

public struct CheckAddressResponse {

    public let status: CheckAddressStatus
    public let normalizedAddress: AddressCheck

}

extension CheckAddressResponse: JSONInitializable {

    fileprivate struct Keys {
        static let status = "status"
        static let normalizedAddress = "normalized_address"
    }

    init?(json: JSON) {
        guard let statusRaw = json[Keys.status].string,
            let status = CheckAddressStatus(rawValue: statusRaw),
            let normalizedAddress = AddressCheck(json: json[Keys.normalizedAddress])
            else { return nil }

        self.init(status: status,
                  normalizedAddress: normalizedAddress)
    }

}
