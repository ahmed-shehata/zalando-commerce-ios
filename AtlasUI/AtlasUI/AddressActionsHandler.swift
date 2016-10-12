//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class AddressActionsHandler {

    private let checkout: AtlasCheckout
    private weak var viewController: AddressPickerViewController?

    init(checkout: AtlasCheckout, viewController: AddressPickerViewController?) {
        self.checkout = checkout
        self.viewController = viewController
    }

}

extension AddressActionsHandler {

    func createAddress() {
        viewController?.createAddressViewControllerGenerator? { [weak self] viewController in
            self?.showCreateAddressViewController(viewController)  { createdAddress in
                self?.viewController?.tableviewDelegate.addresses.append(createdAddress)
                self?.viewController?.addressSelectedHandler?(address: createdAddress)
            }
        }
    }

    private func showCreateAddressViewController(viewController: AddressFormViewController, completion: AddressFormCompletion) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .OverCurrentContext
        self.viewController?.navigationController?.showViewController(navigationController, sender: nil)
    }

}

extension AddressActionsHandler {

    func updateAddress(address: EquatableAddress) {
        showUpdateAddressViewController(for: address) { [weak self] updatedAddress in
            guard let addressIdx = self?.viewController?.tableviewDelegate.addresses.indexOf({ $0 == updatedAddress }) else { return }
            self?.viewController?.tableviewDelegate.addresses[addressIdx] = updatedAddress
            self?.viewController?.addressUpdatedHandler?(address: updatedAddress)
        }
    }

    private func showUpdateAddressViewController(for address: EquatableAddress, completion: AddressFormCompletion) {
        let addressType: AddressFormType = address.pickupPoint == nil ? .StandardAddress : .PickupPoint
        let viewController = AddressFormViewController(addressType: addressType,
                                                       addressMode: .updateAddress(address: address),
                                                       checkout: checkout,
                                                       completion: completion)
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }

}

extension AddressActionsHandler {

    func deleteAddress(address: EquatableAddress) {
        checkout.client.deleteAddress(address.id) { [weak self] result in
            guard let _ = result.process() else { return }
            self?.viewController?.tableviewDelegate.addresses.remove = updatedAddress
            self.deleteAddress(indexPath, tableView: tableView)
        }
    }

    private func deleteAddress(indexPath: NSIndexPath, tableView: UITableView) {

        self.addresses.removeAtIndex(indexPath.item)

        if self.addresses.isEmpty {
            tableView.setEditing(true, animated: true)
        }

        self.deleteAddressHandler?()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

}

extension AddressActionsHandler {

    func selectAddress(address: EquatableAddress) {

    }

}
