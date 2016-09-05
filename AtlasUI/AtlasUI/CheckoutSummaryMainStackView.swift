//
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
        view.borderColor = UIColor(hex: 0xE5E5E5)
        return view
    }()

    internal let shippingAddressStackView: CheckoutSummaryActionRowStackView = {
        let stackView = CheckoutSummaryActionRowStackView()
        stackView.axis = .Horizontal
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    internal let shippingAddressSeparatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.leadingMargin = 15
        view.borderColor = UIColor(hex: 0xE5E5E5)
        return view
    }()

    internal let billingAddressStackView: CheckoutSummaryActionRowStackView = {
        let stackView = CheckoutSummaryActionRowStackView()
        stackView.axis = .Horizontal
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    internal let billingAddressSeparatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.leadingMargin = 15
        view.borderColor = UIColor(hex: 0xE5E5E5)
        return view
    }()

    internal let paymentStackView: CheckoutSummaryActionRowStackView = {
        let stackView = CheckoutSummaryActionRowStackView()
        stackView.axis = .Horizontal
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    internal let paymentSeparatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.borderColor = UIColor(hex: 0xE5E5E5)
        return view
    }()

    internal let priceStackView: CheckoutSummaryPriceStackView = {
        let stackView = CheckoutSummaryPriceStackView()
        stackView.axis = .Vertical
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
    }

    func configureConstraints() {
        fillInSuperView()
        setWidthAsSuperViewWidth()

        shippingAddressStackView.setHeightEqualToView(billingAddressStackView)
        shippingAddressStackView.setHeightEqualToView(paymentStackView)

        productSeparatorView.setHeightToConstant(10)
        shippingAddressSeparatorView.setHeightToConstant(1)
        billingAddressSeparatorView.setHeightToConstant(1)
        paymentSeparatorView.setHeightToConstant(1)
    }

    func builderSubViews() -> [UIBuilder] {
        return [productStackView, shippingAddressStackView, billingAddressStackView, paymentStackView, priceStackView]
    }

}

extension CheckoutSummaryMainStackView: UIDataBuilder {

    typealias T = CheckoutSummaryViewController

    func configureData(viewModel: T) {
        productStackView.configureData(viewModel)
        priceStackView.configureData(viewModel)
        priceStackView.hidden = !viewModel.viewState.showPrice

        shippingAddressStackView.configureData(CheckoutSummaryActionViewModel(
            title: viewModel.loc("Address.Shipping"),
            value: viewModel.checkoutViewModel.shippingAddress(localizedWith: viewModel).trimmed,
            showArrow: viewModel.viewState.showDetailArrow)
        )

        billingAddressStackView.configureData(CheckoutSummaryActionViewModel(
            title: viewModel.loc("Address.Billing"),
            value: viewModel.checkoutViewModel.billingAddress(localizedWith: viewModel).trimmed,
            showArrow: viewModel.viewState.showDetailArrow)
        )

        paymentStackView.configureData(CheckoutSummaryActionViewModel(
            title: viewModel.loc("Payment"),
            value: viewModel.checkoutViewModel.selectedPaymentMethod ?? "",
            showArrow: viewModel.viewState.showDetailArrow)
        )
    }

}
