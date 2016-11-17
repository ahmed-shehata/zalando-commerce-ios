//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

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

    private let viewModel: AddressFormViewModel
    private let actionHandler: AddressFormActionHandler?

    init(viewModel: AddressFormViewModel, actionHandler: AddressFormActionHandler?) {
        self.viewModel = viewModel
        self.actionHandler = actionHandler
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
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "address-edit-right-button"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Localizer.string("button.general.save"),
                                                            style: .Plain,
                                                            target: self,
                                                            action: #selector(submitButtonPressed))

        if viewModel.layout.displayCancelButton {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: Localizer.string("button.general.cancel"),
                                                               style: .Plain,
                                                               target: self,
                                                               action: #selector(cancelButtonPressed))
        }
    }

    private dynamic func cancelButtonPressed() {
        dismissView(true) { }
    }

    private dynamic func submitButtonPressed() {
        view.endEditing(true)

        let isValid = addressStackView.textFields.map { $0.validateForm() }.filter { $0 == false }.isEmpty
        guard isValid else { return }

        navigationItem.rightBarButtonItem?.enabled = false
        actionHandler?.submitButtonPressed(viewModel.dataModel)
    }

}

extension AddressFormViewController: AddressFormActionHandlerDelegate {

    func addressProcessingFinished() {
        navigationItem.rightBarButtonItem?.enabled = true
    }

    func dismissView(animated: Bool, completion: (() -> Void)?) {
        view.endEditing(true)

        if viewModel.layout.dismissViewByPoping {
            navigationController?.popViewControllerAnimated(animated)
            completion?()
        } else {
            dismissViewControllerAnimated(animated, completion: completion)
        }
    }

}

