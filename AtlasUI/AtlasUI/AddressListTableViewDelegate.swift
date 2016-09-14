//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class AddressListTableViewDelegate: NSObject {

    internal var checkout: AtlasCheckout
    private let addressType: AddressType
    private let selectionCompletion: AddressSelectionCompletion
    internal var addAddressHandler: AddAddressHandler?
    internal var editAddressSelectionHandler: EditAddressSelectionHandler?

    var addresses: [UserAddress] = []
    var selectedAddress: EquatableAddress? {
        didSet {
            Async.main { [weak self] in
                guard let strongSelf = self, selectedAddress = strongSelf.selectedAddress else { return }
                strongSelf.selectionCompletion(pickedAddress: selectedAddress, pickedAddressType: strongSelf.addressType)
            }
        }
    }

    init(checkout: AtlasCheckout, addressType: AddressType,
        addressSelectionCompletion: AddressSelectionCompletion) {
            self.checkout = checkout
            self.addressType = addressType
            self.selectionCompletion = addressSelectionCompletion
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
            switch editingStyle {
            case .Delete:
                let address = self.addresses[indexPath.item]
                checkout.client.deleteAddress(address.id) { result in
                    switch result {
                    case .success(_):
                        self.addresses.removeAtIndex(indexPath.item)
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    case .failure(let error):
                        AtlasLogger.logError(error)
                    }
                }
            default:
                break
            }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard indexPath.row < addresses.count else {
            addAddressHandler?()
            return
        }

        if tableView.editing {
            editAddressSelectionHandler?(address: addresses[indexPath.item])
        } else {
            selectedAddress = addresses[indexPath.item]
            tableView.reloadData()
        }
    }

}
