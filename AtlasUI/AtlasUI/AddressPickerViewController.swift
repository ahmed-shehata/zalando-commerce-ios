//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

protocol AddressPickerViewControllerDelegate: class {
    func addressPickerViewController(viewController: AddressPickerViewController,
        pickedAddress address: Address,
        forAddressType addressType: AddressPickerViewController.AddressType)
}

final class AddressPickerViewController: UIViewController {

    enum AddressType {
        case shipping
        case billing
    }

    weak var delegate: AddressPickerViewControllerDelegate?

    private let checkoutService: AtlasCheckout

    private let addressType: AddressType

    init(checkout: AtlasCheckout, addressType: AddressType) {
        self.checkoutService = checkout
        self.addressType = addressType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        switch addressType {
        case .billing:
            self.title = "Billing Address"
        case .shipping:
            self.title = "Shipping Address"
        }

        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        activityIndicatorView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        activityIndicatorView.startAnimating()

        fetchAddresses()
    }

    private func fetchAddresses() {
        checkoutService.client.fetchAddressList { [weak self] result in
            guard let strongSelf = self else { return }
            dispatch_async(dispatch_get_main_queue()) {
                switch result {
                case .success(let addressList):
                    strongSelf.showAddressListViewController(addressList.addresses)
                case .failure(let error):
                    print("failed to fetch address list \(error)")
                    // TODO: Bubble up the error
                    // UserMessage.showError(title: strongSelf.checkoutService.loc("Fatal Error"), error: error)
                }
            }
        }
    }

    private func showAddressListViewController(addresses: [Address]) {
        let selectedAddress: Address?

        switch addressType {
        case .billing:
            selectedAddress = addresses.filter { $0.isDefaultBilling }.first
        case .shipping:
            selectedAddress = addresses.filter { $0.isDefaultShipping }.first
        }

        let addressListViewController = AddressListViewController(addresses: addresses, selectedAddress: selectedAddress)
        addressListViewController.delegate = self
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

extension AddressPickerViewController: AddressListViewControllerDelegate {
    private func addressListViewController(viewController: AddressListViewController, didSelectAddress address: Address) {
        delegate?.addressPickerViewController(self, pickedAddress: address, forAddressType: addressType)
    }
}

private protocol AddressListViewControllerDelegate: class {
    func addressListViewController(viewController: AddressListViewController,
        didSelectAddress address: Address)
}

private final class AddressRowViewCell: UITableViewCell {

    var address: Address! {
        didSet {
            updateViews()
        }
    }

    private let titleLabel = UILabel()

    private let streetLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private struct Metrics {
        static let topPadding: CGFloat = 10
        static let bottomPadding: CGFloat = 10
        static let leadingPadding: CGFloat = 15
        static let trailingPadding: CGFloat = 15
    }

    private func setupViews() {
        contentView.backgroundColor = .clearColor()

        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraintEqualToAnchor(contentView.topAnchor, constant: Metrics.topPadding).active = true
        titleLabel.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor, constant: Metrics.leadingPadding).active = true
        titleLabel.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor, constant: -Metrics.trailingPadding).active = true

        streetLabel.translatesAutoresizingMaskIntoConstraints = false
        streetLabel.numberOfLines = 0
        contentView.addSubview(streetLabel)
        streetLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor).active = true
        streetLabel.leadingAnchor.constraintEqualToAnchor(titleLabel.leadingAnchor).active = true
        streetLabel.trailingAnchor.constraintEqualToAnchor(titleLabel.trailingAnchor).active = true
        streetLabel.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor, constant: -Metrics.bottomPadding).active = true
    }

    private func updateViews() {
        titleLabel.text = address.firstName

        var lines = [String]()

        if let street = address.street {
            lines.append(street)
        }

        lines.append("\(address.zip) \(address.city)")
        lines.append(address.countryCode)

        streetLabel.text = lines.joinWithSeparator("\n")
    }
}

private final class AddressListViewController: UITableViewController {

    private var delegate: AddressListViewControllerDelegate?

    private let addresses: [Address]

    private var selectedAddress: Address? {
        didSet {
            if let selectedAddress = selectedAddress, oldValue = oldValue where selectedAddress != oldValue {
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.addressListViewController(self, didSelectAddress: selectedAddress)
                }
            }
        }
    }

    init(addresses: [Address], selectedAddress: Address?) {
        self.addresses = addresses
        self.selectedAddress = selectedAddress
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(AddressRowViewCell.self, forCellReuseIdentifier: String(AddressRowViewCell))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }

    private override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }

    private override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(
            String(AddressRowViewCell), forIndexPath: indexPath) as? AddressRowViewCell else {
                fatalError("Failed to dequeue an AddressRowViewCell")
        }
        let address = addresses[indexPath.item]
        cell.address = address

        if let selectedAddress = selectedAddress where selectedAddress == address {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }

        return cell
    }

    private override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var indexPathsToReload = [indexPath]

        if let selectedAddress = selectedAddress, index = addresses.indexOf(selectedAddress) {
            indexPathsToReload.append(NSIndexPath(forItem: index, inSection: 0))
        }

        let address = addresses[indexPath.item]
        selectedAddress = address
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadRowsAtIndexPaths(indexPathsToReload, withRowAnimation: .Automatic)
    }
}
