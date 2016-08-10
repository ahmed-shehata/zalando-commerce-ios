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
        self.viewController.stackView.trailingAnchor.constraintEqualToAnchor(self.viewController.view.trailingAnchor).active = true
        self.viewController.stackView.leadingAnchor.constraintEqualToAnchor(self.viewController.view.leadingAnchor).active = true
        self.viewController.stackView.bottomAnchor.constraintLessThanOrEqualToAnchor(self.viewController.view.bottomAnchor).active = true
        self.viewController.stackView.topAnchor.constraintEqualToAnchor(self.viewController.purchasedObjectSummaryLabel.bottomAnchor,
            constant: 10).active = true

        if let shippingViewText = self.viewController.checkoutViewModel.shippingAddressText, shippingView = self.viewController.shippingView(shippingViewText) {
            self.viewController.stackView.addArrangedSubviewSideFilled(shippingView)
            shippingView.heightAnchor.constraintEqualToConstant(55).active = true
        }

        if let cardText = self.viewController.checkoutViewModel.paymentMethodText, cardView = self.viewController.cardView(cardText) {
            self.viewController.stackView.addArrangedSubviewSideFilled(cardView)
            cardView.heightAnchor.constraintEqualToConstant(40).active = true
        }

        if let discountViewText = self.viewController.checkoutViewModel.discountText, discountView = self.viewController.discountView(discountViewText) {
            self.viewController.stackView.addArrangedSubviewSideFilled(discountView)
            discountView.heightAnchor.constraintEqualToConstant(40).active = true
        }

        if let paymentSummaryRow = self.viewController.paymentSummaryRow() {
            self.viewController.stackView.addArrangedSubviewSideFilled(paymentSummaryRow)
            paymentSummaryRow.heightAnchor.constraintEqualToConstant(60).active = true
        }

        if let topSeparatorView = self.viewController.topSeparatorView() {
            self.viewController.stackView.addSubview(topSeparatorView)
            topSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
            topSeparatorView.widthAnchor.constraintEqualToAnchor(self.viewController.stackView.widthAnchor, multiplier: 0.95).active = true
            topSeparatorView.bottomAnchor.constraintEqualToAnchor(self.viewController.stackView.topAnchor).active = true
            topSeparatorView.centerXAnchor.constraintEqualToAnchor(self.viewController.stackView.centerXAnchor).active = true
        }
    }

}
