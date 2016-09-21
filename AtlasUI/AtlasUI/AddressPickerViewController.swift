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
typealias CreateAddressHandler = () -> Void
typealias UpdateAddressHandler = (address: EquatableAddress) -> Void

final class AddressPickerViewController: UIViewController, CheckoutProviderType {

    internal var checkout: AtlasCheckout
    private let addressType: AddressType
    private let selectionCompletion: AddressSelectionCompletion

    private let tableView = UITableView()

    internal let loaderView: LoaderView = {
        let view = LoaderView()
        view.hidden = true
        return view
    }()

    private var addresses: [UserAddress] = [] {
        didSet {
            tableviewDelegate?.addresses = addresses
            tableView.reloadData()
        }
    }
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
        self.view.addSubview(loaderView)
        switch addressType {
        case .billing:
            self.title = "Billing Address"
        case .shipping:
            self.title = "Shipping Address"
        }
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationController?.navigationBar.accessibilityIdentifier = "address-picker-navigation-bar"
        self.navigationItem.rightBarButtonItem?.accessibilityIdentifier = "address-picker-right-button"

        setupView()
        fetchAddresses()
        configureTableviewDelegate()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setEditing(false, animated: false)
    }

    private func configureTableviewDelegate() {
        configureCreateAddress()
        configureUpdateAddress()
    }

    private func fetchAddresses() {
        loaderView.show()
        checkout.client.addresses { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.loaderView.hide()
            Async.main {
                switch result {
                case .failure(let error):
                    strongSelf.userMessage.show(error: error)
                case .success(let addresses):
                    strongSelf.addresses = addresses
                }
            }
        }
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    func setupView() {
        tableView.fillInSuperView()
        loaderView.fillInSuperView()
        loaderView.buildView()

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

    private func configureCreateAddress() {
        tableviewDelegate?.createAddressHandler = { [weak self] in
            guard let strongSelf = self else { return }
            guard strongSelf.addressType == .shipping else {
                strongSelf.showCreateAddress(.StandardAddress)
                return
            }

            let title = strongSelf.loc("Address.Add.type.title")
            let standardAction = ButtonAction(text: "Address.Add.type.standard", style: .Default) { (UIAlertAction) in
                strongSelf.showCreateAddress(.StandardAddress)
            }
            let pickupPointAction = ButtonAction(text: "Address.Add.type.pickupPoint", style: .Default) { (UIAlertAction) in
                strongSelf.showCreateAddress(.PickupPoint)
            }
            let cancelAction = ButtonAction(text: "Cancel", style: .Cancel, handler: nil)

            strongSelf.userMessage.show(title: title,
                                        message: nil,
                                        preferredStyle: .ActionSheet,
                                        actions: standardAction, pickupPointAction, cancelAction)
        }
    }

    private func showCreateAddress(addressType: AddressFormType) {
        showCreateAddressViewController(addressType) { [weak self] editAddressViewModel in
            guard let request = CreateAddressRequest(addressFormViewModel: editAddressViewModel) else { return }
            self?.loaderView.show()
            self?.checkout.client.createAddress(request) { result in
                guard let strongSelf = self else { return }
                strongSelf.loaderView.hide()
                Async.main {
                    switch result {
                    case .failure(let error):
                        strongSelf.userMessage.show(error: error)
                    case .success(let address):
                        strongSelf.addresses.append(address)
                    }
                }
            }
        }
    }

    private func showCreateAddressViewController(type: AddressFormType, completion: AddressFormCompletion) {
        let viewController = AddressFormViewController(addressType: type,
                                                       addressMode: .createAddress,
                                                       checkout: checkout,
                                                       completion: completion)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .OverCurrentContext
        self.navigationController?.showViewController(navigationController, sender: nil)
    }

}

extension AddressPickerViewController {

    private func configureUpdateAddress() {
        tableviewDelegate?.updateAddressHandler = { [weak self] (address) in
            self?.showUpdateAddress(address)
        }
    }

    private func showUpdateAddress(address: EquatableAddress) {
        let addressType: AddressFormType = address.pickupPoint == nil ? .StandardAddress : .PickupPoint
        showUpdateAddressViewController(addressType, address: address) { [weak self] editAddressViewModel in
            guard let request = UpdateAddressRequest(addressFormViewModel: editAddressViewModel) else { return }
            self?.loaderView.show()
            self?.checkout.client.updateAddress(address.id, request: request) { result in
                guard let strongSelf = self else { return }
                strongSelf.loaderView.hide()
                Async.main {
                    switch result {
                    case .failure(let error):
                        strongSelf.userMessage.show(error: error)
                    case .success(let address):
                        let idx = strongSelf.addresses.indexOf { $0 == address }
                        if let addressIdx = idx {
                            strongSelf.addresses[addressIdx] = address
                        }
                    }
                }
            }
        }
    }

    private func showUpdateAddressViewController(type: AddressFormType, address: EquatableAddress, completion: AddressFormCompletion) {
        let viewController = AddressFormViewController(addressType: type,
                                                       addressMode: .updateAddress(address: address),
                                                       checkout: checkout,
                                                       completion: completion)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
