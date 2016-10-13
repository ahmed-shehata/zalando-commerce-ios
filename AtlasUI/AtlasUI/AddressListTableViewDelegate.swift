//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class AddressListTableViewDelegate: NSObject {

    internal var addresses: [EquatableAddress] {
        didSet {
            if let selectedAddress = selectedAddress where !addresses.contains({ $0 == selectedAddress }) {
                self.selectedAddress = nil
            }
            if addresses.isEmpty {
                tableView.setEditing(true, animated: true)
            }
            tableView.reloadData()
        }
    }

    private let tableView: UITableView
    private var selectedAddress: EquatableAddress?
    private weak var actionsHandler: AddressActionsHandler?

    init(tableView: UITableView, addresses: [EquatableAddress], selectedAddress: EquatableAddress?, actionsHandler: AddressActionsHandler) {
        self.tableView = tableView
        self.addresses = addresses
        self.selectedAddress = selectedAddress
        self.actionsHandler = actionsHandler
    }

}

extension AddressListTableViewDelegate: UITableViewDataSource {

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

extension AddressListTableViewDelegate: UITableViewDelegate {

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.row < addresses.count
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {

        guard editingStyle == .Delete else { return }
        let address = addresses[indexPath.item]
        actionsHandler?.deleteAddress(address)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard indexPath.row < addresses.count else {
            actionsHandler?.createAddress()
            return
        }

        let address = addresses[indexPath.item]
        if tableView.editing {
            actionsHandler?.updateAddress(address)
        } else {
            actionsHandler?.selectAddress(address)
        }
    }

}
