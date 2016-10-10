//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

@available( *, deprecated, message = "Kill it with fire!")
enum AddressType {
    case shipping
    case billing
}

typealias AddressSelectionCompletion = (pickedAddress: EquatableAddress?, pickedAddressType: AddressType,
    popBackToSummaryOnFinish: Bool) -> Void
typealias CreateAddressHandler = () -> Void
typealias UpdateAddressHandler = (address: EquatableAddress) -> Void
typealias DeleteAddressHandler = () -> Void

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

    var tableviewDelegate: AddressListTableViewDelegate?

    var selectedAddress: EquatableAddress? {
        didSet {
            tableviewDelegate?.selectedAddress = selectedAddress
        }
    }

    init(checkout: AtlasCheckout, addressType: AddressType, addressSelectionCompletion: AddressSelectionCompletion) {
        self.checkout = checkout
        self.addressType = addressType
        selectionCompletion = addressSelectionCompletion
        super.init(nibName: nil, bundle: nil)
        tableviewDelegate = AddressListTableViewDelegate(checkout: checkout, addressType: addressType,
            addressSelectionCompletion: selectionCompletion)
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
            self.title = Localizer.string("Address.Billing")
        case .shipping:
            self.title = Localizer.string("Address.Shipping")
        }

        self.navigationController?.navigationBar.accessibilityIdentifier = "address-picker-navigation-bar"

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
        configureDeleteAddress()
    }

    private func fetchAddresses() {
        loaderView.show()
        checkout.client.addresses { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.loaderView.hide()
            guard let addresses = result.process() else { return }
            strongSelf.setTableViewDataSource(addresses)
        }
    }

    private func setTableViewDataSource(addresses: [UserAddress]) {
        self.tableviewDelegate?.addresses = addresses
        if addressType == AddressType.billing {
            self.tableviewDelegate?.addresses = addresses.filter({ $0.pickupPoint == nil })
        }
        self.tableView.reloadData()
        self.configureEditButton()
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

            let title = Localizer.string("Address.Add.type.title")
            let standardAction = ButtonAction(text: "Address.Add.type.standard", style: .Default) { (UIAlertAction) in
                strongSelf.showCreateAddress(.StandardAddress)
            }
            let pickupPointAction = ButtonAction(text: "Address.Add.type.pickupPoint", style: .Default) { (UIAlertAction) in
                strongSelf.showCreateAddress(.PickupPoint)
            }
            let cancelAction = ButtonAction(text: "Cancel", style: .Cancel, handler: nil)

            UserMessage.show(title: title,
                preferredStyle: .ActionSheet,
                actions: standardAction, pickupPointAction, cancelAction)
        }
    }

    private func showCreateAddress(addressType: AddressFormType) {
        showCreateAddressViewController(addressType) { [weak self] address in
            guard let strongSelf = self else { return }
            strongSelf.selectionCompletion(pickedAddress: address,
                pickedAddressType: strongSelf.addressType,
                popBackToSummaryOnFinish: true)
            strongSelf.navigationController?.popViewControllerAnimated(false)
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
        tableviewDelegate?.updateAddressHandler = { [weak self] address in
            self?.showUpdateAddress(address)
        }
    }

    private func showUpdateAddress(originalAddress: EquatableAddress) {
        showUpdateAddressViewController(for: originalAddress) { [weak self] updatedAddress in
            guard let strongSelf = self else { return }
            strongSelf.tableviewDelegate?.replaceUpdatedAddress(updatedAddress)
            strongSelf.fetchAddresses()
        }
    }

    private func showUpdateAddressViewController(for address: EquatableAddress, completion: AddressFormCompletion) {
        let addressType: AddressFormType = address.pickupPoint == nil ? .StandardAddress : .PickupPoint
        let viewController = AddressFormViewController(addressType: addressType,
            addressMode: .updateAddress(address: address),
            checkout: checkout,
            completion: completion)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}

extension AddressPickerViewController {

    private func configureDeleteAddress() {
        tableviewDelegate?.deleteAddressHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.configureEditButton()
            strongSelf.selectionCompletion(pickedAddress: strongSelf.selectedAddress,
                pickedAddressType: strongSelf.addressType, popBackToSummaryOnFinish: false)
        }
    }

    private func configureEditButton() {
        if let addressList = tableviewDelegate?.addresses where addressList.isEmpty {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            self.navigationItem.rightBarButtonItem = self.editButtonItem()
            self.navigationItem.rightBarButtonItem?.accessibilityIdentifier = "address-picker-right-button"
        }
    }
}
