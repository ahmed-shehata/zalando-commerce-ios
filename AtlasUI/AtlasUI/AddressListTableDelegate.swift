//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class AddressListTableDelegate: NSObject {

    var addresses: [EquatableAddress] {
        didSet {
            if let selectedAddress = selectedAddress where !addresses.contains({ $0 == selectedAddress }) {
                self.selectedAddress = nil
            }
            tableView.reloadData()
        }
    }

    private let tableView: UITableView
    private var selectedAddress: EquatableAddress?
    private weak var viewController: AddressListViewController?

    init(tableView: UITableView,
         addresses: [EquatableAddress],
         selectedAddress: EquatableAddress?,
         viewController: AddressListViewController) {

        self.tableView = tableView
        self.addresses = addresses
        self.selectedAddress = selectedAddress
        self.viewController = viewController
        super.init()
        self.viewController?.actionHandler?.delegate = self
    }

}

extension AddressListTableDelegate: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard indexPath.row < addresses.count else {
            return tableView.dequeueReusableCell(AddAddressTableViewCell.self, forIndexPath: indexPath) { cell in
                cell.accessibilityIdentifier = "addresses-table-create-address-cell"
                return cell
            }
        }

        return tableView.dequeueReusableCell(AddressRowViewCell.self, forIndexPath: indexPath) { cell in
            let address = self.addresses[indexPath.item]
            cell.configureData(address)

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

extension AddressListTableDelegate: UITableViewDelegate {

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.row < addresses.count
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {

        guard editingStyle == .Delete else { return }
        let address = addresses[indexPath.item]
        viewController?.actionHandler?.deleteAddress(address)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard indexPath.row < addresses.count else {
            viewController?.actionHandler?.createAddress()
            return
        }

        let address = addresses[indexPath.item]
        if tableView.editing {
            viewController?.actionHandler?.updateAddress(address)
        } else {
            addressSelected(address)
        }
    }

}

extension AddressListTableDelegate: AddressListActionHandlerDelegate {

    func addressCreated(address: EquatableAddress) {
        addresses.append(address)
        addressSelected(address)
    }

    func addressUpdated(address: EquatableAddress) {
        guard let addressIdx = addresses.indexOf({ $0 == address }) else { return }
        addresses[addressIdx] = address
        viewController?.addressUpdatedHandler?(address: address)
    }

    func addressDeleted(address: EquatableAddress) {
        guard let addressIdx = addresses.indexOf({ $0 == address }) else { return }
        addresses.removeAtIndex(addressIdx)
        viewController?.configureEditButton()
        viewController?.addressDeletedHandler?(address: address)
    }

    private func addressSelected(address: EquatableAddress) {
        viewController?.addressSelectedHandler?(address: address)
        viewController?.navigationController?.popViewControllerAnimated(true)
    }

}
