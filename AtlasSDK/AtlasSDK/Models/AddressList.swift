//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

public struct AddressList {

    public var isEmpty: Bool {
        return addresses.isEmpty
    }

    public let addresses: [UserAddress]

}

extension AddressList: JSONInitializable {

    init?(json: JSON) {
        let addresses = json.arrayValue.flatMap { UserAddress(json: $0) }
        self.init(addresses: addresses)
    }

}
