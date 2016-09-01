//
//  CheckoutSummaryMainStackView.swift
//  AtlasUI
//
//  Created by Hani Ibrahim Ibrahim Eloksh on 01/09/16.
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryMainStackView: UIStackView {

    internal let productStackView: CheckoutSummaryProductStackView = {
        let stackView = CheckoutSummaryProductStackView()
        stackView.axis = .Horizontal
        stackView.spacing = 15
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    internal let productSeparatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.borderColor = UIColor(netHex: 0xE5E5E5)
        return view
    }()

    internal let shippingStackView: CheckoutSummaryActionRowStackView = {
        let stackView = CheckoutSummaryActionRowStackView()
        stackView.axis = .Horizontal
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    internal let shippingSeparatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.borderColor = UIColor(netHex: 0xE5E5E5)
        return view
    }()

    internal let billingStackView: CheckoutSummaryActionRowStackView = {
        let stackView = CheckoutSummaryActionRowStackView()
        stackView.axis = .Horizontal
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    internal let billingSeparatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.borderColor = UIColor(netHex: 0xE5E5E5)
        return view
    }()

    internal let paymentStackView: CheckoutSummaryActionRowStackView = {
        let stackView = CheckoutSummaryActionRowStackView()
        stackView.axis = .Horizontal
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    internal let paymentSeparatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.borderColor = UIColor(netHex: 0xE5E5E5)
        return view
    }()

}

extension CheckoutSummaryMainStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(productStackView)
        addArrangedSubview(productSeparatorView)

        addArrangedSubview(shippingStackView)
        addArrangedSubview(shippingSeparatorView)

        addArrangedSubview(billingStackView)
        addArrangedSubview(billingSeparatorView)

        addArrangedSubview(paymentStackView)
        addArrangedSubview(paymentSeparatorView)
    }

    func configureConstraints() {
        fillInSuperView()
        setWidthAsSuperViewWidth()

        shippingStackView.setHeightEqualToView(billingStackView)
        shippingStackView.setHeightEqualToView(paymentStackView)

        productSeparatorView.setHeightToConstant(10)
        shippingSeparatorView.setHeightToConstant(1)
        billingSeparatorView.setHeightToConstant(1)
        paymentSeparatorView.setHeightToConstant(1)
    }

    func builderSubViews() -> [UIBuilder] {
        return [productStackView, shippingStackView, billingStackView, paymentStackView]
    }

}
