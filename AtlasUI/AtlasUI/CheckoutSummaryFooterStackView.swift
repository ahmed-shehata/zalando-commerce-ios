//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class CheckoutSummaryFooterStackView: UIStackView {

    fileprivate var legalController: LegalController?

    let recommendationStackView: CheckoutSummaryRecommendationStackView = {
        let stackView = CheckoutSummaryRecommendationStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: -20)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let termsButton: UIButton = {
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
        termsButton.addTarget(self, action: #selector(CheckoutSummaryFooterStackView.tocPressed), for: .touchUpInside)
        addArrangedSubview(termsButton)
        addArrangedSubview(submitButton)
    }

    @objc
    func tocPressed() {
        legalController?.push()
    }

}

extension CheckoutSummaryFooterStackView: UIDataBuilder {

    typealias T = CheckoutSummaryViewModel

    func configure(viewModel: T) {
        if let termsAndConditionsURL = viewModel.dataModel.termsAndConditionsURL {
            legalController = LegalController(tocURL: termsAndConditionsURL)
        }

        if viewModel.layout.showsRecommendationStackView {
            recommendationStackView.configure(viewModel: viewModel.dataModel.selectedArticle.article)
            insertArrangedSubview(recommendationStackView, at: 0)
            recommendationStackView.buildView()
        }

        setupTermsButton(viewModel: viewModel)
        setupSubmitButton(viewModel: viewModel)
    }

    private func setupTermsButton(viewModel: T) {
        termsButton.setAttributedTitle(tocAttributedTitle(), for: .normal)
        termsButton.isHidden = !viewModel.layout.showsFooterLabel
    }

    private func setupSubmitButton(viewModel: T) {
        let isPaypal = viewModel.dataModel.isPayPal
        let readyToCheckout = viewModel.dataModel.isPaymentSelected

        submitButton.setTitle(Localizer.format(string: viewModel.layout.submitButtonTitle(isPaypal: isPaypal)), for: .normal)
        submitButton.backgroundColor = viewModel.layout.submitButtonBackgroundColor(readyToCheckout: readyToCheckout)
        submitButton.accessibilityIdentifier = "checkout-footer-button"
    }

    private func tocAttributedTitle() -> NSAttributedString {
        let underline = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        return NSAttributedString(string: Localizer.format(string: "summaryView.link.termsAndConditions"), attributes: underline)
    }

}
