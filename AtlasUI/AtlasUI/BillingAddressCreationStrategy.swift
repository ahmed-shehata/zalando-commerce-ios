//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct BillingAddressCreationStrategy: AddressCreationStrategy {

    var addressFormCompletion: AddressFormCompletion?
    let availableTypes: [AddressCreationType] = [.standard, .addressBookImport(strategy: ImportAddressBookStrategy())]

}
