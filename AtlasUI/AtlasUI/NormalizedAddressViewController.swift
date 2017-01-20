//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

enum NormalizedAddressResult {
    case selectAddress(address: CheckAddress)
    case editAddress(address: CheckAddress)
    case cancel
    case error
}

typealias NormalizedAddressCompletion = (NormalizedAddressResult) -> Void

class NormalizedAddressViewController: UIViewController {

    let rootStackView: NormalizedAddressStackView = {
        let stackView = NormalizedAddressStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        let editButtonSelector = #selector(editButtonPressed(button:))
        stackView.originalAddressRowView.editButton.addTarget(self, action: editButtonSelector, for: .touchUpInside)
        stackView.suggestedAddressRowView.editButton.addTarget(self, action: editButtonSelector, for: .touchUpInside)
        return stackView
    }()

    let submitButton: RoundedButton = {
        let button = RoundedButton(type: .custom)
        button.cornerRadius = 5
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.setTitle(Localizer.format(string: "button.general.submit"), for: .normal)
        button.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        return button
    }()

    let userAddress: CheckAddress
    let normalizedAddress: CheckAddress
    let completion: NormalizedAddressCompletion

    init(userAddress: CheckAddress, normalizedAddress: CheckAddress, completion: @escaping NormalizedAddressCompletion) {
        self.userAddress = userAddress
        self.normalizedAddress = normalizedAddress
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
        rootStackView.configure(viewModel: (userAddress: userAddress, normalizedAddress: normalizedAddress))
    }

    private func configureNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Localizer.format(string: "button.general.cancel"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(cancelButtonPressed))
        self.title = Localizer.format(string: "addressNormalizedView.title")
    }

    private dynamic func cancelButtonPressed() {
        finish(withResult: .cancel)
    }

    private dynamic func submitButtonPressed() {
        guard let selectedAddress = rootStackView.selectedAddress else {
            finish(withResult: .cancel)
            return
        }

        finish(withResult: .selectAddress(address: selectedAddress))
    }

    private dynamic func editButtonPressed(button: NormalizedAddressRowButton) {
        guard let address = button.address else {
            finish(withResult: .cancel)
            return
        }

        finish(withResult: .editAddress(address: address))
    }

    private func finish(withResult result: NormalizedAddressResult) {
        completion(result)
        dismiss(animated: true, completion: nil)
    }

}

extension NormalizedAddressViewController: UIBuilder {

    func configureView() {
        view.backgroundColor = .white
        view.addSubview(rootStackView)
        view.addSubview(submitButton)
    }

    func configureConstraints() {
        rootStackView.snap(toSuperview: .top)
        rootStackView.snap(toSuperview: .right)
        rootStackView.snap(toSuperview: .left)

        submitButton.snap(toSuperview: .right, constant: -20)
        submitButton.snap(toSuperview: .left, constant: 20)
        submitButton.snap(toSuperview: .bottom, constant: -10)
    }

}
