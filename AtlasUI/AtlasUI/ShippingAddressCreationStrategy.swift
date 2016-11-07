//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct ShippingAddressCreationStrategy: AddressCreationStrategy {

    var addressFormCompletion: AddressFormCompletion?
    let availableTypes: [AddressCreationType] = [.standard, .pickupPoint, .addressBookImport(strategy: ImportAddressBookStrategy())]

}
