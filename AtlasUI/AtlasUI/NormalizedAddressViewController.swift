//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class NormalizedAddressViewController: UIViewController {

    let rootStackView: NormalizedAddressStackView = {
        let stackView = NormalizedAddressStackView()
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

    let userAddress: CheckAddress
    let normalizedAddress: CheckAddress
    init(userAddress: CheckAddress, normalizedAddress: CheckAddress) {
        self.userAddress = userAddress
        self.normalizedAddress = normalizedAddress
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        rootStackView.configure(viewModel: (userAddress: userAddress, normalizedAddress: normalizedAddress))
    }

}

extension NormalizedAddressViewController: UIBuilder {

    func configureView() {
        view.backgroundColor = .white
        view.addSubview(rootStackView)
        view.addSubview(submitButton)
    }

    func configureConstraints() {
        rootStackView.snap(toSuperview: .top, constant: 44)
        rootStackView.snap(toSuperview: .right)
        rootStackView.snap(toSuperview: .left)

        submitButton.snap(toSuperview: .right, constant: -20)
        submitButton.snap(toSuperview: .left, constant: 20)
        submitButton.snap(toSuperview: .bottom, constant: -10)
    }

}
