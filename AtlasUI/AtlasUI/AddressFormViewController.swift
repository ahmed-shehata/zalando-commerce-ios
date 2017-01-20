//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

typealias AddressFormCompletion = (_ address: EquatableAddress, _ email: String?) -> Void

class AddressFormViewController: UIViewController {

    let scrollView: KeyboardScrollView = {
        let scrollView = KeyboardScrollView()
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()

    lazy var addressStackView: AddressFormStackView = {
        let stackView = AddressFormStackView()
        stackView.addressType = self.viewModel.type
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    var completion: AddressFormCompletion?

    fileprivate let viewModel: AddressFormViewModel
    fileprivate let actionHandler: AddressFormActionHandler?

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
        view.backgroundColor = .white
        buildView()
        addressStackView.configure(viewModel: viewModel.dataModel)
        configureNavigation()
    }

    func present() {
        if viewModel.layout.displayViewModally {
            let navigationController = UINavigationController(rootViewController: self)
            navigationController.modalPresentationStyle = .overCurrentContext
            AtlasUIViewController.shared?.show(navigationController, sender: nil)
        } else {
            AtlasUIViewController.shared?.mainNavigationController.pushViewController(self, animated: true)
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
        scrollView.fillInSuperview()
        addressStackView.fillInSuperview()
        addressStackView.setWidth(equalToView: scrollView)
    }

}

extension AddressFormViewController {

    fileprivate func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Localizer.format(string: "button.general.save"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(submitButtonPressed))
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "address-edit-right-button"

        if viewModel.layout.displayCancelButton {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: Localizer.format(string: "button.general.cancel"),
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(cancelButtonPressed))
        }
    }

    fileprivate dynamic func cancelButtonPressed() {
        dismissView()
    }

    fileprivate dynamic func submitButtonPressed() {
        view.endEditing(true)

        let isValid = addressStackView.textFields.map { $0.validateForm() }.filter { $0 == false }.isEmpty
        guard isValid else { return }

        navigationItem.rightBarButtonItem?.isEnabled = false
        actionHandler?.submit(dataModel: viewModel.dataModel)
    }

    fileprivate func dismissView(animated: Bool = true, completion: (() -> Void)? = nil) {
        view.endEditing(true)

        if viewModel.layout.displayViewModally {
            dismiss(animated: animated, completion: completion)
        } else {
            _ = navigationController?.popViewController(animated: animated)
            completion?()
        }
    }

}

extension AddressFormViewController: AddressFormActionHandlerDelegate {

    func addressProcessingFinished() {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }

    func dismissView(withAddress address: EquatableAddress, animated: Bool) {
        dismissView(animated: animated) { [weak self] in
            self?.completion?(address, self?.viewModel.dataModel.email)
        }
    }

    func updateView(withDataModel dataModel: AddressFormDataModel) {
        addressStackView.configure(viewModel: dataModel)
    }

}
