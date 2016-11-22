//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct LoggedInAddressListActionHandler: AddressListActionHandler {

    var addressViewModelCreationStrategy: AddressViewModelCreationStrategy?
    weak var delegate: AddressListActionHandlerDelegate?

    init(addressViewModelCreationStrategy: AddressViewModelCreationStrategy?) {
        self.addressViewModelCreationStrategy = addressViewModelCreationStrategy
    }

    func createAddress() {
        createAddress(addressViewModelCreationStrategy, formActionHandler: LoggedInCreateAddressActionHandler())
    }

    func updateAddress(address: EquatableAddress) {
        updateAddress(address, formActionHandler: LoggedInUpdateAddressActionHandler())
    }

    func deleteAddress(address: EquatableAddress) {
        AtlasUIClient.deleteAddress(address.id) { result in
            guard let _ = result.process() else { return }
            self.delegate?.addressDeleted(address)
        }
    }

}
