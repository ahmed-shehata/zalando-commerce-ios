//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class AddressActionsHandler {

    private weak var viewController: AddressPickerViewController?

    init(viewController: AddressPickerViewController?) {
        self.viewController = viewController
    }

    func createAddress() {
        viewController?.addressCreationStrategy?.addressFormCompletion = { [weak self] userAddress in
            self?.viewController?.tableviewDelegate.addresses.append(userAddress)
            self?.selectAddress(userAddress)
        }

        viewController?.addressCreationStrategy?.execute()
    }

    func updateAddress(address: EquatableAddress) {
        showUpdateAddressViewController(for: address) { [weak self] updatedAddress in
            guard let addressIdx = self?.viewController?.tableviewDelegate.addresses.indexOf({ $0 == updatedAddress }) else { return }
            self?.viewController?.tableviewDelegate.addresses[addressIdx] = updatedAddress
            self?.viewController?.addressUpdatedHandler?(address: updatedAddress)
        }
    }

    private func showUpdateAddressViewController(for address: EquatableAddress, completion: AddressFormCompletion) {
        let addressType: AddressFormType = address.pickupPoint == nil ? .standardAddress : .pickupPoint
        let viewController = AddressFormViewController(addressType: addressType,
                                                       addressMode: .updateAddress(address: address),
                                                       completion: completion)
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }

    func deleteAddress(address: EquatableAddress) {
        AtlasAPIClient.deleteAddress(address.id) { [weak self] result in
            let addresses = self?.viewController?.tableviewDelegate.addresses
            guard let _ = result.process(), addressIdx = addresses?.indexOf({ $0 == address }) else { return }

            self?.viewController?.tableviewDelegate.addresses.removeAtIndex(addressIdx)
            self?.viewController?.configureEditButton()
            self?.viewController?.addressDeletedHandler?(address: address)
        }
    }

    func selectAddress(address: EquatableAddress) {
        viewController?.addressSelectedHandler?(address: address)
        viewController?.navigationController?.popViewControllerAnimated(true)
    }

}
