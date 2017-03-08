//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import ZalandoCommerceAPI

enum AddressCheckResult {
    case selectAddress(address: AddressCheck)
    case editAddress(address: AddressCheck)
    case cancel
    case error
}

class AddressCheckViewController: UIViewController {

    let rootStackView: AddressCheckStackView = {
        let stackView = AddressCheckStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let submitButton: RoundedButton = {
        let button = RoundedButton(type: .custom)
        button.cornerRadius = 5
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.setTitle(Localizer.format(string: "button.general.submit"), for: .normal)
        return button
    }()

    let dataModel: AddressCheckDataModel
    let completion: AddressCheckViewControllerCompletion

    init(dataModel: AddressCheckDataModel, completion: @escaping AddressCheckViewControllerCompletion) {
        self.dataModel = dataModel
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        buildView()
        rootStackView.configure(viewModel: dataModel)
        configureButtonsAction()
    }

    private func configureNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Localizer.format(string: "button.general.cancel"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(cancelButtonPressed))
        self.title = Localizer.format(string: "addressCheckView.title")
    }

    private func configureButtonsAction() {
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        rootStackView.addressesRow.forEach { (_, view) in
            view.editButton.addTarget(self, action: #selector(editButtonPressed(button:)), for: .touchUpInside)
        }
    }

    private dynamic func cancelButtonPressed() {
        finish(withResult: .cancel)
    }

    private dynamic func submitButtonPressed() {
        guard let selectedAddress = rootStackView.selectedAddress else { return finish(withResult: .cancel) }

        finish(withResult: .selectAddress(address: selectedAddress))
    }

    private dynamic func editButtonPressed(button: AddressCheckRowButton) {
        guard let address = button.address else { return finish(withResult: .cancel) }

        finish(withResult: .editAddress(address: address))
    }

    private func finish(withResult result: AddressCheckResult) {
        completion(result)
        dismiss(animated: true, completion: nil)
    }

}

extension AddressCheckViewController: UIBuilder {

    func configureView() {
        view.backgroundColor = .white
        view.addSubview(rootStackView)
        view.addSubview(submitButton)
    }

    func configureConstraints() {
        rootStackView.snap(toTopViewController: self)
        rootStackView.snap(toSuperview: .right)
        rootStackView.snap(toSuperview: .left)

        submitButton.snap(toSuperview: .right, constant: -20)
        submitButton.snap(toSuperview: .left, constant: 20)
        submitButton.snap(toSuperview: .bottom, constant: -10)
    }

}
