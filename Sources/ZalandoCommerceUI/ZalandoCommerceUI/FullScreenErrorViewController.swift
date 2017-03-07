//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import ZalandoCommerceAPI

class FullScreenErrorViewController: UIViewController {

    fileprivate let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightRegular)
        label.backgroundColor = UIColor(hex: 0xE5E5E5)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
    }

    func cancelButtonPressed() {
        try? ZalandoCommerceUIViewController.presented?.dismissAtlasCheckoutUI()
    }

}

extension FullScreenErrorViewController: UIBuilder {

    func configureView() {
        view.addSubview(messageLabel)
        let cancelButton = UIBarButtonItem(title: Localizer.format(string: "button.general.cancel"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(cancelButtonPressed))
        navigationItem.rightBarButtonItem = cancelButton
    }

    func configureConstraints() {
        messageLabel.fillInSuperview()
    }

}

extension FullScreenErrorViewController: UIDataBuilder {

    typealias T = UserPresentableError

    func configure(viewModel: T) {
        ZalandoCommerceUIViewController.presented?.dismissalReason = ZalandoCommerceUI.CheckoutResult.finishedWithError(error: viewModel)
        title = viewModel.displayedTitle
        messageLabel.text = viewModel.displayedMessage.uppercased()
    }

}
