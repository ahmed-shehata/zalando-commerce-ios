//
//  Copyright © 2016 Zalando SE. All rights reserved.
//


public struct AddressList {
    public let addresses: [Address]
}

extension AddressList: JSONInitializable {

    init?(json: JSON) {
        let addresses = json.arrayValue.flatMap { Address(json: $0) }
        self.init(addresses: addresses)
    }
}
