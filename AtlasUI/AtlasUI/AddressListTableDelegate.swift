//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

class AddressListTableDelegate: NSObject {

    var addresses: [EquatableAddress] {
        didSet {
            if let selectedAddress = selectedAddress, !addresses.contains(where: { $0 == selectedAddress }) {
                self.selectedAddress = nil
            }
            tableView.reloadData()
        }
    }

    fileprivate let tableView: UITableView
    fileprivate var selectedAddress: EquatableAddress?
    fileprivate weak var viewController: AddressListViewController?

    init(tableView: UITableView,
         addresses: [EquatableAddress],
         selectedAddress: EquatableAddress?,
         viewController: AddressListViewController?) {

        self.tableView = tableView
        self.addresses = addresses
        self.selectedAddress = selectedAddress
        self.viewController = viewController
        super.init()
        self.viewController?.actionHandler?.delegate = self
    }

}

extension AddressListTableDelegate: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < addresses.count else {
            return tableView.dequeueReusableCell(of: AddAddressTableViewCell.self, at: indexPath) { cell in
                cell.accessibilityIdentifier = "addresses-table-create-address-cell"
                return cell
            }
        }

        return tableView.dequeueReusableCell(of: AddressRowViewCell.self, at: indexPath) { cell in
            let address = self.addresses[indexPath.item]
            cell.configure(viewModel: address)

            if let selectedAddress = self.selectedAddress, selectedAddress == address {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            cell.accessibilityIdentifier = "address-selection-row-\(indexPath.row)"

            return cell
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row < addresses.count
    }

}

extension AddressListTableDelegate: UITableViewDelegate {

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {

        guard editingStyle == .delete else { return }
        let address = addresses[indexPath.item]
        viewController?.actionHandler?.delete(address: address)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < addresses.count else {
            viewController?.actionHandler?.createAddress()
            return
        }

        let address = addresses[indexPath.item]
        if tableView.isEditing {
            viewController?.actionHandler?.update(address: address)
        } else {
            selected(address: address)
        }
    }

}

extension AddressListTableDelegate: AddressListActionHandlerDelegate {

    func created(address: EquatableAddress) {
        addresses.append(address)
        selected(address: address)
    }

    func updated(address: EquatableAddress) {
        guard let addressIdx = addresses.index(where: { $0 == address }) else { return }
        addresses[addressIdx] = address
        viewController?.addressUpdatedHandler?(address)
    }

    func deleted(address: EquatableAddress) {
        guard let addressIdx = addresses.index(where: { $0 == address }) else { return }
        addresses.remove(at: addressIdx)
        viewController?.configureEditButton()
        viewController?.addressDeletedHandler?(address)
    }

    fileprivate func selected(address: EquatableAddress) {
        viewController?.addressSelectedHandler?(address)
        _ = viewController?.navigationController?.popViewController(animated: true)
    }

}
