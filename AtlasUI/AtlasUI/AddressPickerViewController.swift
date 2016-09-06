//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

enum AddressType {
    case shipping
    case billing
}

typealias AddressSelectionCompletion = (pickedAddress: Addressable, pickedAddressType: AddressType) -> Void

final class AddressPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CheckoutProviderType {

    internal var checkout: AtlasCheckout
    private let addressType: AddressType
    private let selectionCompletion: AddressSelectionCompletion

    private let tableView = UITableView()
    private var addresses: [Address] = []

    var selectedAddress: Addressable? {
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
            super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        switch addressType {
        case .billing:
            self.title = "Billing Address"
        case .shipping:
            self.title = "Shipping Address"
        }
        self.setupTableView()
        fetchAddresses()
    }

    private func fetchAddresses() {
        checkout.client.fetchAddressList { [weak self] result in
            guard let strongSelf = self else { return }
            Async.main {
                switch result {
                case .failure(let error):
                    strongSelf.userMessage.show(error: error)
                case .success(let addressList):
                    strongSelf.addresses = addressList.addresses
                    strongSelf.tableView.reloadData()
                }
            }
        }
    }

    func setupTableView() {

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.fillInSuperView()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerReusableCell(AddressRowViewCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        self.parentViewController?.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            if editingStyle == .Delete {
                let address = self.addresses[indexPath.item]
                checkout.client.deleteAddress(address.id) { result in
                    switch result {
                    case .success(_):
                        self.addresses.removeAtIndex(indexPath.item)
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    case .failure(let error):
                        self.userMessage.show(error: error)
                    }
                }
            }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(AddressRowViewCell.self, forIndexPath: indexPath) { result in
            switch result {
            case let .dequeuedCell(addressRowCell):
                let address = self.addresses[indexPath.item]
                addressRowCell.address = address
                addressRowCell.accessoryType = self.selectedAddress?.id == address.id ? .Checkmark : .None
                return addressRowCell
            case let .defaultCell(cell):
                return cell
            }
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedAddress = addresses[indexPath.item]

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadData()
    }

    private func showAddressListViewController(addresses: [Address]) {
        let addressListViewController = AddressListViewController(checkout: checkout, addresses: addresses,
            addressType: addressType, addressSelectionCompletion: selectionCompletion)
        addressListViewController.selectedAddress = selectedAddress
        addChildViewController(addressListViewController)
        addressListViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addressListViewController.view)
        addressListViewController.view.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true

        addressListViewController.view.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        addressListViewController.view.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor).active = true
        addressListViewController.view.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        addressListViewController.didMoveToParentViewController(self)
    }

}
