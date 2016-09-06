//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class EditAddressViewController: UIViewController {

    internal let scrollView: KeyboardScrollView = {
        let scrollView = KeyboardScrollView()
        scrollView.keyboardDismissMode = .Interactive
        return scrollView
    }()

    internal let addressStackView: EditAddressStackView = {
        let stackView = EditAddressStackView()
        stackView.axis = .Vertical
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

//    var address: Address
//
//    init(address: Address = Address()) {
//        self.address = address
//        super.init(nibName: nil, bundle: nil)
//    
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        buildView()
        addressStackView.configureData(true)
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
