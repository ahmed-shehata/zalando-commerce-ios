//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

typealias AddressFormCompletion = EquatableAddress -> Void

class AddressFormViewController: UIViewController {

    let scrollView: KeyboardScrollView = {
        let scrollView = KeyboardScrollView()
        scrollView.keyboardDismissMode = .Interactive
        return scrollView
    }()

    lazy var addressStackView: AddressFormStackView = {
        let stackView = AddressFormStackView()
        stackView.addressType = self.viewModel.type
        stackView.axis = .Vertical
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    var completion: AddressFormCompletion?
    private let viewModel: AddressFormViewModel
    private let actionHandler: AddressFormActionHandler?

    init(viewModel: AddressFormViewModel, actionHandler: AddressFormActionHandler?, completion: AddressFormCompletion?) {
        self.viewModel = viewModel
        self.actionHandler = actionHandler
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
        self.actionHandler?.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        buildView()
        addressStackView.configureData(viewModel.dataModel)
        configureNavigation()
    }

    func displayView() {
        if viewModel.layout.displayViewModally {
            let navigationController = UINavigationController(rootViewController: self)
            navigationController.modalPresentationStyle = .OverCurrentContext
            AtlasUIViewController.instance?.showViewController(navigationController, sender: nil)
        } else {
            AtlasUIViewController.instance?.mainNavigationController.pushViewController(self, animated: true)
        }
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

    private func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Localizer.string("button.general.save"),
                                                            style: .Plain,
                                                            target: self,
                                                            action: #selector(submitButtonPressed))
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "address-edit-right-button"

        if viewModel.layout.displayCancelButton {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: Localizer.string("button.general.cancel"),
                                                               style: .Plain,
                                                               target: self,
                                                               action: #selector(cancelButtonPressed))
        }
    }

    private dynamic func cancelButtonPressed() {
        dismissView(true)
    }

    private dynamic func submitButtonPressed() {
        view.endEditing(true)

        let isValid = addressStackView.textFields.map { $0.validateForm() }.filter { $0 == false }.isEmpty
        guard isValid else { return }

        navigationItem.rightBarButtonItem?.enabled = false
        actionHandler?.submitButtonPressed(viewModel.dataModel)
    }

    private func dismissView(animated: Bool, completion: (() -> Void)? = nil) {
        view.endEditing(true)

        if viewModel.layout.displayViewModally {
            dismissViewControllerAnimated(animated, completion: completion)
        } else {
            navigationController?.popViewControllerAnimated(animated)
            completion?()
        }
    }

}

extension AddressFormViewController: AddressFormActionHandlerDelegate {

    func addressProcessingFinished() {
        navigationItem.rightBarButtonItem?.enabled = true
    }

    func dismissView(withAddress address: EquatableAddress, animated: Bool) {
        dismissView(animated) { [weak self] in
            self?.completion?(address)
        }
    }

}
