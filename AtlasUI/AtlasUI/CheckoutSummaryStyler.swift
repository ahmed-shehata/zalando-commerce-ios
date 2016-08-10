//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class CheckoutSummaryStyler {

    private let viewController: CheckoutSummaryViewController

    init(checkoutSummaryViewController: CheckoutSummaryViewController) {
        self.viewController = checkoutSummaryViewController
    }

    func stylize () {
        setupStackView()
    }

    private func setupStackView() {
        self.viewController.stackView.removeAllSubviews()

        self.viewController.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.viewController.stackView.axis = .Vertical
        self.viewController.stackView.distribution = .Fill
        self.viewController.stackView.alignment = .Center
        self.viewController.stackView.spacing = 2
        self.viewController.stackView.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true
        self.viewController.stackView.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
        self.viewController.stackView.bottomAnchor.constraintLessThanOrEqualToAnchor(self.view.bottomAnchor).active = true
        self.viewController.stackView.topAnchor.constraintEqualToAnchor(purchasedObjectSummaryLabel.bottomAnchor, constant: 10).active = true

        if let shippingViewText = checkoutViewModel.shippingAddressText, shippingView = shippingView(shippingViewText) {
            self.viewController.stackView.addArrangedSubviewSideFilled(shippingView)
            shippingView.heightAnchor.constraintEqualToConstant(55).active = true
        }

        if let cardText = checkoutViewModel.paymentMethodText, cardView = cardView(cardText) {
            self.viewController.stackView.addArrangedSubviewSideFilled(cardView)
            cardView.heightAnchor.constraintEqualToConstant(40).active = true
        }

        if let discountViewText = checkoutViewModel.discountText, discountView = discountView(discountViewText) {
            self.viewController.stackView.addArrangedSubviewSideFilled(discountView)
            discountView.heightAnchor.constraintEqualToConstant(40).active = true
        }

        if let paymentSummaryRow = paymentSummaryRow() {
            self.viewController.stackView.addArrangedSubviewSideFilled(paymentSummaryRow)
            paymentSummaryRow.heightAnchor.constraintEqualToConstant(60).active = true
        }

        if let topSeparatorView = topSeparatorView() {
            self.viewController.stackView.addSubview(topSeparatorView)
            topSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
            topSeparatorView.widthAnchor.constraintEqualToAnchor(stackView.widthAnchor, multiplier: 0.95).active = true
            topSeparatorView.bottomAnchor.constraintEqualToAnchor(stackView.topAnchor).active = true
            topSeparatorView.centerXAnchor.constraintEqualToAnchor(stackView.centerXAnchor).active = true
        }
    }

}