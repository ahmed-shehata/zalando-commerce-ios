//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

protocol AddressPickerViewControllerDelegate: class {
    func addressPickerViewController(viewController: AddressPickerViewController,
        pickedAddress address: Address,
        forAddressType addressType: AddressType)
}

enum AddressType {
    case shipping
    case billing
}

final class AddressPickerViewController: UIViewController, CheckoutProviderType {

    weak var delegate: AddressPickerViewControllerDelegate?
    internal var checkout: AtlasCheckout
    private let addressType: AddressType
    private let selectionCompletion: (pickedAddress: Address, pickedAddressType: AddressType) -> Void

    init(checkout: AtlasCheckout, addressType: AddressType,
        addressSelectionCompletion: (pickedAddress: Address, pickedAddressType: AddressType) -> Void) {
            self.checkout = checkout
            self.addressType = addressType
            self.selectionCompletion = addressSelectionCompletion
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
        checkout.client.fetchAddressList { [weak self] result in
            guard let strongSelf = self else { return }
            Async.main {
                switch result {
                case .failure(let error):
                    strongSelf.userMessage.show(error: error)
                case .success(let addressList):
                    strongSelf.showAddressListViewController(addressList.addresses)
                }
            }
        }
    }

    private func showAddressListViewController(addresses: [Address]) {
        let selectedAddress: Address? = nil

        let addressListViewController = AddressListViewController(addresses: addresses, selectedAddress: selectedAddress, addressType: addressType, addressSelectionCompletion: selectionCompletion)

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
    internal func addressListViewController(viewController: AddressListViewController, didSelectAddress address: Address) {
        delegate?.addressPickerViewController(self, pickedAddress: address, forAddressType: addressType)
    }
}
protocol AddressListViewControllerDelegate: class {
    func addressListViewController(viewController: AddressListViewController,
        didSelectAddress address: Address)
}
