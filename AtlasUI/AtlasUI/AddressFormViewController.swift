//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

typealias AddressFormCompletion = UserAddress -> Void

class AddressFormViewController: UIViewController {

    let scrollView: KeyboardScrollView = {
        let scrollView = KeyboardScrollView()
        scrollView.keyboardDismissMode = .Interactive
        return scrollView
    }()

    lazy var addressStackView: AddressFormStackView = {
        let stackView = AddressFormStackView()
        stackView.addressType = self.addressType
        stackView.axis = .Vertical
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let addressType: AddressFormType
    private let addressMode: AddressFormMode
    let checkout: AtlasUI
    private let addressViewModel: AddressFormViewModel
    var completion: AddressFormCompletion?

    init(addressType: AddressFormType, addressMode: AddressFormMode, checkout: AtlasUI, completion: AddressFormCompletion?) {
        self.addressType = addressType
        self.addressMode = addressMode
        self.checkout = checkout
        self.completion = completion
        let countryCode = checkout.client.config.salesChannel.countryCode

        switch addressMode {
        case .createAddress(let addressViewModel): self.addressViewModel = addressViewModel
        case .updateAddress(let address): self.addressViewModel = AddressFormViewModel(equatableAddress: address, countryCode: countryCode)
        }

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
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "address-edit-right-button"
    }

}

extension AddressFormViewController {

    private func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Localizer.string("button.general.save"),
                                                            style: .Plain,
                                                            target: self,
                                                            action: #selector(submitButtonPressed))

        switch addressMode {
        case .createAddress:
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: Localizer.string("button.general.cancel"),
                                                               style: .Plain,
                                                               target: self,
                                                               action: #selector(cancelButtonPressed))
        case .updateAddress:
            break
        }
    }

    private dynamic func submitButtonPressed() {
        view.endEditing(true)

        let isValid = addressStackView.textFields.map { $0.validateForm() }.filter { $0 == false }.isEmpty
        guard isValid else { return }

        disableSaveButton()
        checkAddressRequest()
    }

    private dynamic func cancelButtonPressed() {
        dismissView()
    }

    private func dismissView() {
        view.endEditing(true)

        switch addressMode {
        case .createAddress: dismissViewControllerAnimated(true, completion: nil)
        case .updateAddress: navigationController?.popViewControllerAnimated(true)
        }
    }

    private func enableSaveButton() {
        navigationItem.rightBarButtonItem?.enabled = true
    }

    private func disableSaveButton() {
        navigationItem.rightBarButtonItem?.enabled = false
    }

}

extension AddressFormViewController: UIBuilder {

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

}

extension AddressFormViewController {

    private func checkAddressRequest() {
        guard let request = CheckAddressRequest(addressFormViewModel: addressViewModel) else { return enableSaveButton() }
        UserMessage.displayLoader { [weak self] hideLoader in
            self?.checkout.client.checkAddress(request) { [weak self] result in
                hideLoader()
                self?.checkAddressRequestCompletion(result)
            }
        }
    }

    private func createAddressRequest() {
        guard let request = CreateAddressRequest(addressFormViewModel: addressViewModel) else { return enableSaveButton() }
        UserMessage.displayLoader { [weak self] hideLoader in
            self?.checkout.client.createAddress(request) { [weak self] result in
                hideLoader()
                self?.createUpdateAddressRequestCompletion(result)
            }
        }
    }

    private func updateAddressRequest(originalAddress: EquatableAddress) {
        guard let request = UpdateAddressRequest(addressFormViewModel: addressViewModel) else { return enableSaveButton() }
        UserMessage.displayLoader { [weak self] hideLoader in
            self?.checkout.client.updateAddress(originalAddress.id, request: request) { [weak self] result in
                hideLoader()
                self?.createUpdateAddressRequestCompletion(result)
            }
        }
    }

    private func checkAddressRequestCompletion(result: AtlasResult<CheckAddressResponse>) {
        guard let checkAddressResponse = result.process() else { return enableSaveButton() }
        if checkAddressResponse.status == .notCorrect {
            UserMessage.displayError(AtlasCheckoutError.addressInvalid)
            enableSaveButton()
        } else {
            switch addressMode {
            case .createAddress: createAddressRequest()
            case .updateAddress(let address): updateAddressRequest(address)
            }
        }
    }

    private func createUpdateAddressRequestCompletion(result: AtlasResult<UserAddress>) {
        guard let address = result.process() else { return enableSaveButton() }
        dismissView()
        completion?(address)
    }

}
