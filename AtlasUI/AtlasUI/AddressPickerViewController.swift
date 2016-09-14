//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

enum AddressType {
    case shipping
    case billing
}

typealias AddressSelectionCompletion = (pickedAddress: EquatableAddress, pickedAddressType: AddressType) -> Void
typealias AddAddressHandler = Void -> Void
typealias EditAddressSelectionHandler = (address: EquatableAddress) -> Void

final class AddressPickerViewController: UIViewController, CheckoutProviderType {

    internal var checkout: AtlasCheckout
    private let addressType: AddressType
    private let selectionCompletion: AddressSelectionCompletion

    private let tableView = UITableView()
    private var addresses: [UserAddress] = []
    let tableviewDelegate: AddressListTableViewDelegate?

    var selectedAddress: EquatableAddress? {
        didSet {
            tableviewDelegate?.selectedAddress = selectedAddress
        }
    }

    init(checkout: AtlasCheckout, addressType: AddressType,
        addressSelectionCompletion: AddressSelectionCompletion) {
            self.checkout = checkout
            self.addressType = addressType
            selectionCompletion = addressSelectionCompletion
            tableviewDelegate = AddressListTableViewDelegate(checkout: checkout,
                addressType: addressType, addressSelectionCompletion: selectionCompletion)

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
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.setupTableView()
        fetchAddresses()
        configureTableviewDelegate()
    }

    private func configureTableviewDelegate() {
        configureAddNewAddress()
        configureEditAddress()
    }

    private func fetchAddresses() {
        checkout.client.addresses { [weak self] result in
            guard let strongSelf = self else { return }
            Async.main {
                switch result {
                case .failure(let error):
                    strongSelf.userMessage.show(error: error)
                case .success(let addresses):
                    strongSelf.addresses = addresses
                    strongSelf.tableviewDelegate?.addresses = addresses
                    strongSelf.tableView.reloadData()
                }
            }
        }
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    func setupTableView() {
        tableView.fillInSuperView()

        tableView.delegate = tableviewDelegate
        tableView.dataSource = tableviewDelegate
        tableView.registerReusableCell(AddressRowViewCell.self)
        tableView.registerReusableCell(AddAddressTableViewCell.self)
        tableView.allowsSelectionDuringEditing = true
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.reloadData()

    }

}

extension AddressPickerViewController {

    private func showAddAddress(type: EditAddressType, address: EquatableAddress?, completion: EditAddressCompletion) {
        let viewController = EditAddressViewController(addressType: type, checkout: checkout, address: address, completion: completion)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .OverCurrentContext
        self.navigationController?.showViewController(navigationController, sender: nil)
    }

    private func configureAddNewAddress() {
        tableviewDelegate?.addAddressHandler = { [weak self] in
            guard let strongSelf = self else { return }

            let addAddressCompletion: EditAddressCompletion = {
                // TODO: Call Add Webservice
                print($0)
            }

            guard strongSelf.addressType == .shipping else {
                strongSelf.showAddAddress(.StandardAddress, address: nil, completion: addAddressCompletion)
                return
            }

            let title = strongSelf.loc("Address.Add.type.title")
            let standardAction = ButtonAction(text: strongSelf.loc("Address.Add.type.standard"), style: .Default) { (UIAlertAction) in
                strongSelf.showAddAddress(.StandardAddress, address: nil, completion: addAddressCompletion)
            }
            let pickupPointAction = ButtonAction(text: strongSelf.loc("Address.Add.type.pickupPoint"), style: .Default) { (UIAlertAction) in
                strongSelf.showAddAddress(.PickupPoint, address: nil, completion: addAddressCompletion)
            }
            let cancelAction = ButtonAction(text: strongSelf.loc("Cancel"), style: .Cancel, handler: nil)

            strongSelf.userMessage.show(title: title,
                                        message: nil,
                                        actions: standardAction, pickupPointAction, cancelAction,
                                        preferredStyle: .ActionSheet)
        }
    }

    private func configureEditAddress() {
        tableviewDelegate?.editAddressSelectionHandler = { [weak self] (address) in
            let addressType: EditAddressType = address.pickupPoint == nil ? .StandardAddress : .PickupPoint
            self?.showAddAddress(addressType, address: address) {
                // TODO: Call Edit Webservice
                print($0)
            }
        }
    }

}
