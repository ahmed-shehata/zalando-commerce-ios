//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

typealias AddressUpdatedHandler = (_ address: EquatableAddress) -> Void
typealias AddressDeletedHandler = (_ address: EquatableAddress) -> Void
typealias AddressSelectedHandler = (_ address: EquatableAddress) -> Void

final class AddressListViewController: UIViewController {

    var addressUpdatedHandler: AddressUpdatedHandler?
    var addressDeletedHandler: AddressDeletedHandler?
    var addressSelectedHandler: AddressSelectedHandler?
    var actionHandler: AddressListActionHandler?

    // swiftlint:disable:next weak_delegate
    lazy var tableviewDelegate: AddressListTableDelegate = {
        return AddressListTableDelegate(tableView: self.tableView,
                                        addresses: self.initialAddresses,
                                        selectedAddress: self.initialSelectedAddress,
                                        viewController: self)
    }()

    fileprivate let initialAddresses: [EquatableAddress]
    fileprivate let initialSelectedAddress: EquatableAddress?

    fileprivate let tableView: UITableView = {
        let tableView = UITableView()
        tableView.registerReusableCell(for: AddressRowViewCell.self)
        tableView.registerReusableCell(for: AddAddressTableViewCell.self)
        tableView.allowsSelectionDuringEditing = true
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        return tableView
    }()

    init(initialAddresses: [EquatableAddress], selectedAddress: EquatableAddress?) {
        self.initialAddresses = initialAddresses
        self.initialSelectedAddress = selectedAddress
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEditing(false, animated: false)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

}

extension AddressListViewController: UIBuilder {

    func configureView() {
        view.addSubview(tableView)
        configureEditButton()
        configureTableView()

        navigationController?.navigationBar.accessibilityIdentifier = "address-picker-navigation-bar"
    }

    func configureConstraints() {
        tableView.fillInSuperview()
    }

    func configureEditButton() {
        if tableviewDelegate.addresses.isEmpty {
            setEditing(false, animated: false)
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = editButtonItem
            navigationItem.rightBarButtonItem?.accessibilityIdentifier = "address-picker-right-button"
        }
    }

    fileprivate func configureTableView() {
        tableView.delegate = tableviewDelegate
        tableView.dataSource = tableviewDelegate
        tableView.reloadData()
    }

}
