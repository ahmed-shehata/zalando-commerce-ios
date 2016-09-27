//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class AddressListTableViewDelegate: NSObject {

    internal var checkout: AtlasCheckout
    private let addressType: AddressType
    private let selectionCompletion: AddressSelectionCompletion
    private let userMessage: UserMessage
    internal var createAddressHandler: CreateAddressHandler?
    internal var updateAddressHandler: UpdateAddressHandler?
    internal var deleteAddressHandler: DeleteAddressHandler?

    var addresses: [UserAddress] = []
    var selectedAddress: EquatableAddress?
    init(checkout: AtlasCheckout, addressType: AddressType, userMessage: UserMessage,
        addressSelectionCompletion: AddressSelectionCompletion) {
            self.checkout = checkout
            self.addressType = addressType
            self.selectionCompletion = addressSelectionCompletion
            self.userMessage = userMessage
    }
}

extension AddressListTableViewDelegate: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard indexPath.row < addresses.count else {
            return tableView.dequeueReusableCell(AddAddressTableViewCell.self, forIndexPath: indexPath) { cell in
                cell.configureData(self.checkout)
                cell.accessibilityIdentifier = "addresses-table-create-address-cell"
                return cell
            }
        }

        return tableView.dequeueReusableCell(AddressRowViewCell.self, forIndexPath: indexPath) { cell in
            let address = self.addresses[indexPath.item]
            cell.configureData(AddressRowCellViewModel(userAddress: address, localizer: self.checkout))
            if let selectedAddress = self.selectedAddress where selectedAddress == address {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }

            cell.accessibilityIdentifier = "address-selection-row-\(indexPath.row)"
            return cell
        }
    }

}

extension AddressListTableViewDelegate: UITableViewDelegate {

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.row < addresses.count
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {

        guard editingStyle == .Delete else { return }

        let address = self.addresses[indexPath.item]
        checkout.client.deleteAddress(address.id) { result in
            guard let _ = result.success(errorHandlingType: .GeneralError(userMessage: self.userMessage)) else { return }
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard indexPath.row < addresses.count else {
            createAddressHandler?()
            return
        }

        if tableView.editing {
            updateAddressHandler?(address: addresses[indexPath.item])
        } else {
            selectedAddress = addresses[indexPath.item]
            self.selectionCompletion(pickedAddress: addresses[indexPath.item],
                pickedAddressType: self.addressType,
                popBackToSummaryOnFinish: true)
            tableView.reloadData()
        }
    }

}
