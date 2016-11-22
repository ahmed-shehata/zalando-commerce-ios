//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

struct GuestCheckoutAddressListActionHandler: AddressListActionHandler {

    var addressViewModelCreationStrategy: AddressViewModelCreationStrategy?
    weak var delegate: AddressListActionHandlerDelegate?

    init(addressViewModelCreationStrategy: AddressViewModelCreationStrategy?) {
        self.addressViewModelCreationStrategy = addressViewModelCreationStrategy
    }

    func createAddress() {
        createAddress(addressViewModelCreationStrategy, formActionHandler: GuestCheckoutCreateAddressActionHandler())
    }

    func updateAddress(address: EquatableAddress) {
        updateAddress(address, formActionHandler: GuestCheckoutUpdateAddressActionHandler())
    }

    func deleteAddress(address: EquatableAddress) {
        delegate?.addressDeleted(address)
    }

}
