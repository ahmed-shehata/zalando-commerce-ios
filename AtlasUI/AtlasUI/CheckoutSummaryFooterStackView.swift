//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class CheckoutSummaryFooterStackView: UIStackView {

    fileprivate var legalController: LegalController?

    let footerButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: UIFontWeightLight)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = UIColor(hex: 0x7F7F7F)
        button.accessibilityIdentifier = "checkout-summary-toc-button"
        return button
    }()

    let submitButton: RoundedButton = {
        let button = RoundedButton(type: .custom)
        button.cornerRadius = 5
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.white, for: UIControlState())
        button.backgroundColor = UIColor(hex: 0x519415)
        return button
    }()

}

extension CheckoutSummaryFooterStackView: UIBuilder {

    func configureView() {
        footerButton.addTarget(self, action: #selector(CheckoutSummaryFooterStackView.tocPressed(_:)), for: .touchUpInside)
        addArrangedSubview(footerButton)
        addArrangedSubview(submitButton)
    }

    @objc func tocPressed(_ sender: UIButton!) {
        legalController?.push()
    }

}

extension CheckoutSummaryFooterStackView: UIDataBuilder {

    typealias T = CheckoutSummaryViewModel

    func configure(viewModel: T) {
        if let termsAndConditionsURL = viewModel.dataModel.termsAndConditionsURL {
            legalController = LegalController(tocURL: termsAndConditionsURL)
        }

        footerButton.setAttributedTitle(tocAttributedTitle(), for: UIControlState())
        footerButton.isHidden = !viewModel.layout.showFooterLabel

        let isPaypal = viewModel.dataModel.isPayPal
        let readyToCheckout = viewModel.dataModel.isPaymentSelected

        submitButton.setTitle(Localizer.string(viewModel.layout.submitButtonTitle(isPaypal: isPaypal)), for: UIControlState())
        submitButton.backgroundColor = viewModel.layout.submitButtonBackgroundColor(readyToCheckout: readyToCheckout)
        submitButton.accessibilityIdentifier = "checkout-footer-button"
    }

    fileprivate func tocAttributedTitle() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: Localizer.string("summaryView.link.termsAndConditions"))
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
        return attributedString
    }

}
