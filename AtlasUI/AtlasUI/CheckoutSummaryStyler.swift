//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class CheckoutSummaryStyler: LocalizerProviderType {

    private let viewController: CheckoutSummaryViewController
    var localizer: Localizer { return viewController.localizer }

    init(checkoutSummaryViewController: CheckoutSummaryViewController) {
        viewController = checkoutSummaryViewController
    }

    func stylize () {
        stylizeStackView()
        stylizeProductImageView()
        stylizeViewLabels()
        stylizeTermsButton()

        let mainButton = viewController.customer != nil ? viewController.buyButton : viewController.connectToZalandoButton
        stylizeMainButton(mainButton)
    }

    private func stylizeStackView() {
        viewController.stackView.removeAllSubviews()
        viewController.stackView.translatesAutoresizingMaskIntoConstraints = false
        viewController.stackView.axis = .Vertical
        viewController.stackView.distribution = .Fill
        viewController.stackView.alignment = .Center
        viewController.stackView.spacing = 2
        viewController.stackView.trailingAnchor.constraintEqualToAnchor(viewController.view.trailingAnchor).active = true
        viewController.stackView.leadingAnchor.constraintEqualToAnchor(viewController.view.leadingAnchor).active = true
        viewController.stackView.bottomAnchor.constraintLessThanOrEqualToAnchor(viewController.view.bottomAnchor).active = true
        viewController.stackView.topAnchor.constraintEqualToAnchor(viewController.purchasedObjectSummaryLabel.bottomAnchor,
            constant: 10).active = true

        stylizeShippingView()
        stylizeCardView()
        stylizePaymentSummary()

        if let topSeparatorView = viewController.topSeparatorView() {
            viewController.stackView.addSubview(topSeparatorView)
            topSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
            topSeparatorView.widthAnchor.constraintEqualToAnchor(viewController.stackView.widthAnchor, multiplier: 0.95).active = true
            topSeparatorView.bottomAnchor.constraintEqualToAnchor(viewController.stackView.topAnchor).active = true
            topSeparatorView.centerXAnchor.constraintEqualToAnchor(viewController.stackView.centerXAnchor).active = true
        }
    }

    private func stylizeShippingView() {
        if let shippingViewText = viewController.checkoutViewModel.shippingAddressText,
            shippingView = viewController.shippingView(shippingViewText) {
                viewController.stackView.addArrangedSubviewSideFilled(shippingView)
                shippingView.heightAnchor.constraintEqualToConstant(55).active = true
        }
    }

    private func stylizeCardView() {
        if let paymentMethodText = viewController.checkoutViewModel.paymentMethodText,
            cardView = viewController.cardView(paymentMethodText) {
                viewController.stackView.addArrangedSubviewSideFilled(cardView)
                cardView.heightAnchor.constraintEqualToConstant(40).active = true
        }
    }

    private func stylizePaymentSummary() {
        if let paymentSummaryRow = viewController.paymentSummaryRow() {
            viewController.stackView.addArrangedSubviewSideFilled(paymentSummaryRow)
            paymentSummaryRow.heightAnchor.constraintEqualToConstant(60).active = true
        }
    }

    private func stylizeProductImageView () {
        if let article = viewController.checkoutViewModel.article {
            viewController.productImageView.setImage(fromUrl: article.media.images.first?.catalogUrl)
        }

        viewController.productImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        viewController.productImageView.image = UIImage(named: "default-user", bundledWith: CheckoutSummaryViewController.self)

        viewController.productImageView.layer.cornerRadius = viewController.productImageView.frame.size.width / 2
        viewController.productImageView.clipsToBounds = true

        viewController.productImageView.layer.borderWidth = 0.5
        viewController.productImageView.layer.borderColor = UIColor.grayColor().CGColor

        viewController.productImageView.translatesAutoresizingMaskIntoConstraints = false
        viewController.productImageView.widthAnchor.constraintEqualToConstant(50).active = true
        viewController.productImageView.heightAnchor.constraintEqualToAnchor(viewController.productImageView.widthAnchor).active = true
        viewController.productImageView.topAnchor.constraintEqualToAnchor(viewController.view.topAnchor, constant: 50).active = true
        viewController.productImageView.centerXAnchor.constraintEqualToAnchor(viewController.view.centerXAnchor).active = true
    }

    private func stylizeViewLabels() {
        if let article = viewController.checkoutViewModel.article {
            viewController.productNameLabel.text = article.brand.name
            viewController.purchasedObjectSummaryLabel.text = article.name
        }

        viewController.productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        viewController.productNameLabel.textAlignment = .Center
        viewController.productNameLabel.font = viewController.productNameLabel.font.fontWithSize(12)
        viewController.productNameLabel.widthAnchor.constraintEqualToAnchor(viewController.productImageView.widthAnchor,
            multiplier: 2).active = true
        viewController.productNameLabel.heightAnchor.constraintEqualToConstant(20).active = true
        viewController.productNameLabel.topAnchor.constraintEqualToAnchor(viewController.productImageView.bottomAnchor).active = true
        viewController.productNameLabel.centerXAnchor.constraintEqualToAnchor(viewController.productImageView.centerXAnchor).active = true

        viewController.purchasedObjectSummaryLabel.translatesAutoresizingMaskIntoConstraints = false
        viewController.purchasedObjectSummaryLabel.textAlignment = .Center
        viewController.purchasedObjectSummaryLabel.font = viewController.purchasedObjectSummaryLabel.font.fontWithSize(10)

        viewController.purchasedObjectSummaryLabel.heightAnchor.constraintEqualToConstant(15).active = true
        viewController.purchasedObjectSummaryLabel.topAnchor.constraintEqualToAnchor(
            viewController.productNameLabel.bottomAnchor).active = true
        viewController.purchasedObjectSummaryLabel.centerXAnchor.constraintEqualToAnchor(
            viewController.productImageView.centerXAnchor).active = true

    }

    private func stylizeTermsButton () {
        viewController.termsAndConditionsButton.translatesAutoresizingMaskIntoConstraints = false
        let attrs = [NSFontAttributeName: UIFont.systemFontOfSize(12.0),
            NSForegroundColorAttributeName: UIColor.grayColor(),
            NSUnderlineStyleAttributeName: 1]

        viewController.termsAndConditionsButton.setAttributedTitle(NSMutableAttributedString(string:
                loc("CheckoutSummaryViewController.terms"), attributes: attrs), forState: .Normal)

        viewController.termsAndConditionsButton.heightAnchor.constraintEqualToConstant(30).active = true
        viewController.termsAndConditionsButton.titleLabel?.lineBreakMode = .ByWordWrapping
        viewController.termsAndConditionsButton.topAnchor.constraintEqualToAnchor(
            viewController.view.bottomAnchor, constant: -30).active = true
        viewController.termsAndConditionsButton.leadingAnchor.constraintEqualToAnchor(viewController.view.leadingAnchor,
            constant: 10).active = true
        viewController.termsAndConditionsButton.trailingAnchor.constraintEqualToAnchor(viewController.view.trailingAnchor,
            constant: -10).active = true
    }

    private func stylizeMainButton(button: UIButton) {
        button.hidden = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraintEqualToConstant(50).active = true
        button.topAnchor.constraintEqualToAnchor(viewController.termsAndConditionsButton.bottomAnchor,
            constant: -80).active = true
        button.leadingAnchor.constraintEqualToAnchor(viewController.view.leadingAnchor, constant: 10).active = true
        button.trailingAnchor.constraintEqualToAnchor(viewController.view.trailingAnchor, constant: -10).active = true
        let title = viewController.customer != nil ? "Buy Now" : "Connect To Zalando"
        button.setTitle(title, forState: .Normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 5
    }

}
