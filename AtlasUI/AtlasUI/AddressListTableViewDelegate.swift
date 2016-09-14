//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class AddressListTableViewDelegate: NSObject {

    internal var checkout: AtlasCheckout
    private let addressType: AddressType
    private let selectionCompletion: AddressSelectionCompletion

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
        return addresses.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(AddressRowViewCell.self, forIndexPath: indexPath) { result in
            switch result {
            case let .dequeuedCell(addressRowCell):
                let address = self.addresses[indexPath.item]
                addressRowCell.address = address
                if let selectedAddress = self.selectedAddress {
                    addressRowCell.accessoryType = selectedAddress == address ? .Checkmark : .None
                }

                return addressRowCell
            case let .defaultCell(cell):
                return cell
            }
        }
    }

}

extension AddressListTableViewDelegate: UITableViewDelegate {

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
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
        selectedAddress = addresses[indexPath.item]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadData()
    }

}
