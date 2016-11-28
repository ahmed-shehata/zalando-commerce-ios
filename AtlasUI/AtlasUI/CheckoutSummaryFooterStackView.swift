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
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: 0x519415)
        return button
    }()

}

extension CheckoutSummaryFooterStackView: UIBuilder {

    func configureView() {
        footerButton.addTarget(self, action: #selector(CheckoutSummaryFooterStackView.tocPressed), for: .touchUpInside)
        addArrangedSubview(footerButton)
        addArrangedSubview(submitButton)
    }

    @objc func tocPressed() {
        legalController?.push()
    }

}

extension CheckoutSummaryFooterStackView: UIDataBuilder {

    typealias T = CheckoutSummaryViewModel

    func configure(viewModel: T) {
        if let termsAndConditionsURL = viewModel.dataModel.termsAndConditionsURL {
            legalController = LegalController(tocURL: termsAndConditionsURL)
        }

        setupFooterButton(viewModel: viewModel)
        setupSubmitButton(viewModel: viewModel)
    }

    private func setupFooterButton(viewModel: T) {
        footerButton.setAttributedTitle(tocAttributedTitle(), for: .normal)
        footerButton.isHidden = !viewModel.layout.showFooterLabel
    }

    private func setupSubmitButton(viewModel: T) {
        let isPaypal = viewModel.dataModel.isPayPal
        let readyToCheckout = viewModel.dataModel.isPaymentSelected

        submitButton.setTitle(Localizer.string(viewModel.layout.submitButtonTitle(isPaypal: isPaypal)), for: .normal)
        submitButton.backgroundColor = viewModel.layout.submitButtonBackgroundColor(readyToCheckout: readyToCheckout)
        submitButton.accessibilityIdentifier = "checkout-footer-button"
    }

    private func tocAttributedTitle() -> NSAttributedString {
        let underline = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        return NSAttributedString(string: Localizer.string("summaryView.link.termsAndConditions"), attributes: underline)
    }

}
