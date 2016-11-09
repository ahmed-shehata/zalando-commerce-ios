//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class CheckoutSummaryFooterStackView: UIStackView {

    private var legalController: LegalController?

    let footerButton: UIButton = {
        let button = UIButton(type: .System)
        button.titleLabel?.font = .systemFontOfSize(12, weight: UIFontWeightLight)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textAlignment = .Center
        button.titleLabel?.textColor = UIColor(hex: 0x7F7F7F)
        button.accessibilityIdentifier = "checkout-summary-toc-button"
        return button
    }()

    let submitButton: RoundedButton = {
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
        legalController?.push()
    }

}

extension CheckoutSummaryFooterStackView: UIDataBuilder {

    typealias T = CheckoutSummaryViewController

    func configureData(viewModel: T) {
        legalController = LegalController(tocURL: viewModel.checkout.client.config.salesChannel.termsAndConditionsURL)

        footerButton.setAttributedTitle(tocAttributedTitle(), forState: .Normal)
        footerButton.hidden = !viewModel.viewState.showFooterLabel

        let isPaypal = viewModel.checkoutViewModel.checkout?.payment.selected?.isPaypal() ?? false

        submitButton.setTitle(Localizer.string(viewModel.viewState.submitButtonTitle(isPaypal)), forState: .Normal)
        submitButton.backgroundColor = viewModel.viewState.submitButtonBackgroundColor
        submitButton.accessibilityIdentifier = "checkout-footer-button"
    }

    private func tocAttributedTitle() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: Localizer.string("summaryView.link.termsAndConditions"))
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: range)
        return attributedString
    }

}
