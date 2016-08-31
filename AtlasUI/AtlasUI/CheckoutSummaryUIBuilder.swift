//
//  CheckoutSummaryUIBuilder.swift
//  AtlasUI
//
//  Created by Hani Ibrahim Ibrahim Eloksh on 31/08/16.
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class CheckoutSummaryUIBuilder {

    private unowned let viewController: CheckoutSummaryViewController
    private unowned let uiStyler: CheckoutSummaryUIStyler

    init (viewController: CheckoutSummaryViewController, uiStyler: CheckoutSummaryUIStyler) {
        self.viewController = viewController
        self.uiStyler = uiStyler
    }

    internal func setupView() {
        setupOuterStackView()
        setupFooterView()
        setupMainStackView()
        setupProductSummary()
        setupShippingAddress()
    }

    private func setupOuterStackView() {
        viewController.view.addSubview(uiStyler.outerStackView)
        uiStyler.outerStackView.fillInSuperView()
        uiStyler.outerStackView.addArrangedSubview(uiStyler.scrollView)
        uiStyler.outerStackView.addArrangedSubview(uiStyler.footerStackView)
    }

    private func setupFooterView() {
        uiStyler.footerStackView.addArrangedSubview(uiStyler.footerLabel)
        uiStyler.footerStackView.addArrangedSubview(uiStyler.submitButton)
    }

    private func setupMainStackView() {
        uiStyler.scrollView.addSubview(uiStyler.mainStackView)
        uiStyler.mainStackView.fillInSuperView()
        uiStyler.mainStackView.setWidthAsSuperViewWidth()
    }

    private func setupProductSummary() {
        uiStyler.mainStackView.addArrangedSubview(uiStyler.productSummaryStackView)
        uiStyler.mainStackView.addArrangedSubview(uiStyler.productSummarySeparatorView)
        uiStyler.productSummaryStackView.addArrangedSubview(uiStyler.articleImageView)
        uiStyler.productSummaryStackView.addArrangedSubview(uiStyler.productDetailsStackView)
        uiStyler.productDetailsStackView.addArrangedSubview(uiStyler.brandNameLabel)
        uiStyler.productDetailsStackView.addArrangedSubview(uiStyler.articleNameLabel)
        uiStyler.productDetailsStackView.addArrangedSubview(uiStyler.unitSizeLabel)
        uiStyler.productSummarySeparatorView.setHeightToConstant(10)
        uiStyler.articleImageView.setSquareAspectRatio()
        uiStyler.articleImageView.setWidthAsSuperViewWidth(0.2)
    }

    private func setupShippingAddress() {
        uiStyler.mainStackView.addArrangedSubview(uiStyler.shippingAddressStackView)
        uiStyler.mainStackView.addArrangedSubview(uiStyler.shippingAddressSeparatorView)
        uiStyler.shippingAddressStackView.addArrangedSubview(uiStyler.shippingAddressLabelsStackView)
        uiStyler.shippingAddressStackView.addArrangedSubview(uiStyler.shippingAddressArrowImageView)
        uiStyler.shippingAddressLabelsStackView.addArrangedSubview(uiStyler.shippingAddressTitleLabel)
        uiStyler.shippingAddressLabelsStackView.addArrangedSubview(uiStyler.shippingAddressValueLabel)
        uiStyler.shippingAddressSeparatorView.setHeightToConstant(1)
        uiStyler.shippingAddressArrowImageView.setWidthToConstant(20)
    }
}
