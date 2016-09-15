//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

typealias EditAddressCompletion = EditAddressViewModel -> Void

class EditAddressViewController: UIViewController, CheckoutProviderType {

    internal let scrollView: KeyboardScrollView = {
        let scrollView = KeyboardScrollView()
        scrollView.keyboardDismissMode = .Interactive
        return scrollView
    }()

    internal lazy var addressStackView: EditAddressStackView = {
        let stackView = EditAddressStackView()
        stackView.addressType = self.addressType
        stackView.checkoutProviderType = self
        stackView.axis = .Vertical
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let addressType: EditAddressType
    internal let checkout: AtlasCheckout
    private let addressViewModel: EditAddressViewModel
    internal let completion: EditAddressCompletion

    init(addressType: EditAddressType, checkout: AtlasCheckout, address: EquatableAddress?, completion: EditAddressCompletion) {
        self.addressType = addressType
        self.checkout = checkout
        if let userAddress = address as? UserAddress {
            self.addressViewModel = EditAddressViewModel(userAddress: address,
                                                         countryCode: checkout.client.config.countryCode,
                                                         isDefaultBilling: userAddress.isDefaultBilling,
                                                         isDefaultShipping: userAddress.isDefaultShipping)
        } else {
            self.addressViewModel = EditAddressViewModel(userAddress: address,
                                                         countryCode: checkout.client.config.countryCode)
        }
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        buildView()
        addressStackView.configureData(addressViewModel)
        configureNavigation()
    }

}

extension EditAddressViewController {

    private func configureNavigation() {
        let saveButton = UIBarButtonItem(title: loc("Save"), style: .Plain, target: self, action: #selector(submitButtonPressed))
        navigationItem.rightBarButtonItem = saveButton

        if navigationController?.viewControllers.count == 1 {
            let cancelButton = UIBarButtonItem(title: loc("Cancel"), style: .Plain, target: self, action: #selector(cancelButtonPressed))
            navigationItem.leftBarButtonItem = cancelButton
        }
    }

    private dynamic func submitButtonPressed() {
        completion(addressViewModel)
        dismissView()
    }

    private dynamic func cancelButtonPressed() {
        dismissView()
    }

    private func dismissView() {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }

}

extension EditAddressViewController: UIBuilder {

    func configureView() {
        view.addSubview(scrollView)
        scrollView.addSubview(addressStackView)
        scrollView.registerForKeyboardNotifications()
    }

    func configureConstraints() {
        scrollView.fillInSuperView()
        addressStackView.fillInSuperView()
        addressStackView.setWidth(equalToView: scrollView)
    }

    func builderSubviews() -> [UIBuilder] {
        return [addressStackView]
    }

}
