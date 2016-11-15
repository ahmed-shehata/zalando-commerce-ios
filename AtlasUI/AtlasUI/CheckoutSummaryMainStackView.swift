//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryMainStackView: UIStackView {

    let productStackView: CheckoutSummaryProductStackView = {
        let stackView = CheckoutSummaryProductStackView()
        stackView.axis = .Horizontal
        stackView.spacing = 15
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    let productSeparatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.borderColor = UIColor(hex: 0xE5E5E5)
        return view
    }()

    let shippingAddressStackView: CheckoutSummaryAddressStackView = {
        let stackView = CheckoutSummaryAddressStackView()
        stackView.axis = .Horizontal
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.layoutMarginsRelativeArrangement = true
        stackView.accessibilityIdentifier = "shipping-stack-view"
        stackView.setTitle("summaryView.label.address.shipping")
        return stackView
    }()

    let shippingAddressSeparatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.leadingMargin = 15
        view.borderColor = UIColor(hex: 0xE5E5E5)
        return view
    }()

    let billingAddressStackView: CheckoutSummaryAddressStackView = {
        let stackView = CheckoutSummaryAddressStackView()
        stackView.axis = .Horizontal
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.layoutMarginsRelativeArrangement = true
        stackView.accessibilityIdentifier = "billing-stack-view"
        stackView.setTitle("summaryView.label.address.billing")
        return stackView
    }()

    let billingAddressSeparatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.leadingMargin = 15
        view.borderColor = UIColor(hex: 0xE5E5E5)
        return view
    }()

    let paymentStackView: CheckoutSummaryPaymentStackView = {
        let stackView = CheckoutSummaryPaymentStackView()
        stackView.axis = .Horizontal
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.layoutMarginsRelativeArrangement = true
        stackView.setTitle("summaryView.label.payment")
        return stackView
    }()

    let paymentSeparatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.borderColor = UIColor(hex: 0xE5E5E5)
        return view
    }()

    let priceStackView: CheckoutSummaryPriceStackView = {
        let stackView = CheckoutSummaryPriceStackView()
        stackView.axis = .Vertical
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    let deliveryStackView: CheckoutSummaryDeliveryStackView = {
        let stackView = CheckoutSummaryDeliveryStackView()
        stackView.axis = .Horizontal
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

}

extension CheckoutSummaryMainStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(productStackView)
        addArrangedSubview(productSeparatorView)

        addArrangedSubview(shippingAddressStackView)
        addArrangedSubview(shippingAddressSeparatorView)

        addArrangedSubview(billingAddressStackView)
        addArrangedSubview(billingAddressSeparatorView)

        addArrangedSubview(paymentStackView)
        addArrangedSubview(paymentSeparatorView)

        addArrangedSubview(priceStackView)
        addArrangedSubview(deliveryStackView)
    }

    func configureConstraints() {
        fillInSuperView()
        setWidth(equalToView: superview)

        paymentStackView.setHeight(equalToView: billingAddressStackView)
        paymentStackView.setHeight(equalToView: shippingAddressStackView)

        productSeparatorView.setHeight(equalToConstant: 10)
        shippingAddressSeparatorView.setHeight(equalToConstant: 1)
        billingAddressSeparatorView.setHeight(equalToConstant: 1)
        paymentSeparatorView.setHeight(equalToConstant: 1)
    }

}

extension CheckoutSummaryMainStackView: UIDataBuilder {

    typealias T = CheckoutSummaryViewModel

    func configureData(viewModel: T) {
        productStackView.configureData(viewModel.dataModel.selectedArticleUnit)
        priceStackView.configureData(viewModel.dataModel)
        deliveryStackView.configureData(viewModel.dataModel)
        priceStackView.hidden = !viewModel.layout.showPrice

        shippingAddressStackView.configureData(CheckoutSummaryAddressViewModel(
            addressLines: viewModel.dataModel.formattedShippingAddress,
            showArrow: viewModel.layout.showDetailArrow)
        )

        billingAddressStackView.configureData(CheckoutSummaryAddressViewModel(
            addressLines: viewModel.dataModel.formattedBillingAddress,
            showArrow: viewModel.layout.showDetailArrow)
        )

        paymentStackView.configureData(CheckoutSummaryPaymentViewModel(
            value: viewModel.dataModel.paymentMethod ?? "",
            showArrow: viewModel.layout.showDetailArrow)
        )
    }

}
