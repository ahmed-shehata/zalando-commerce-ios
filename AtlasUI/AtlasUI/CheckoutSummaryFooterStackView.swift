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

    typealias T = CheckoutSummaryViewModel

    func configureData(viewModel: T) {
        if let termsAndConditionsURL = viewModel.dataModel.termsAndConditionsURL {
            legalController = LegalController(tocURL: termsAndConditionsURL)
        }

        footerButton.setAttributedTitle(tocAttributedTitle(), forState: .Normal)
        footerButton.hidden = !viewModel.layout.showFooterLabel

        let isPaypal = viewModel.dataModel.isPayPal
        let readyToCheckout = viewModel.dataModel.isPaymentSelected

        submitButton.setTitle(Localizer.string(viewModel.layout.submitButtonTitle(isPaypal: isPaypal)), forState: .Normal)
        submitButton.backgroundColor = viewModel.layout.submitButtonBackgroundColor(readyToCheckout: readyToCheckout)
        submitButton.accessibilityIdentifier = "checkout-footer-button"
    }

    private func tocAttributedTitle() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: Localizer.string("summaryView.link.termsAndConditions"))
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: range)
        return attributedString
    }

}
