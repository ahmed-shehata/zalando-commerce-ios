//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryFooterStackView: UIStackView {

    var tocURL: NSURL?

    internal let footerButton: UIButton = {
        let button = UIButton(type: .System)
        button.titleLabel?.font = .systemFontOfSize(12)
        button.titleLabel?.lineBreakMode = .ByWordWrapping
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .Center
        button.accessibilityIdentifier = "checkout-summary-toc-button"
        return button
    }()

    internal let submitButton: RoundedButton = {
        let button = RoundedButton(type: .Custom)
        button.cornerRadius = 5
        button.titleLabel?.font = .systemFontOfSize(15)
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.backgroundColor = UIColor(hex: 0x519415)
        return button
    }()

}

extension CheckoutSummaryFooterStackView: UIBuilder {

    func configureView() {
        footerButton.addTarget(self, action: #selector(CheckoutSummaryFooterStackView.tocPressed(_:)), forControlEvents: .TouchUpInside)
        addArrangedSubview(footerButton)
        addArrangedSubview(submitButton)
    }

    @objc func tocPressed(sender: UIButton!) {
        if let url = tocURL {
            let controller = ToCViewController(tocURL: url)
            guard let navController = UIApplication.topViewController()?.navigationController else {
                UIApplication.sharedApplication().openURL(url)
                return
            }
            navController.pushViewController(controller, animated: true)
        }
    }

}

extension CheckoutSummaryFooterStackView: UIDataBuilder {

    typealias T = CheckoutSummaryViewController

    func configureData(viewModel: T) {
        tocURL = viewModel.checkout.client.config.tocURL

        footerButton.setTitle(viewModel.loc("CheckoutSummaryViewController.terms"), forState: .Normal)
        footerButton.hidden = !viewModel.viewState.showFooterLabel

        let isPaypal = viewModel.checkoutViewModel.checkout?.payment.selected?.isPaypal() ?? false

        submitButton.setTitle(viewModel.loc(viewModel.viewState.submitButtonTitle(isPaypal)), forState: .Normal)
        submitButton.backgroundColor = viewModel.viewState.submitButtonBackgroundColor
        submitButton.accessibilityIdentifier = "checkout-footer-button"
    }

}
