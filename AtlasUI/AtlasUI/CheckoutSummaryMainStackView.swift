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

    internal let shippingAddressStackView: CheckoutSummaryAddressActionRowStackView = {
        let stackView = CheckoutSummaryAddressActionRowStackView()
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

    internal let billingAddressStackView: CheckoutSummaryAddressActionRowStackView = {
        let stackView = CheckoutSummaryAddressActionRowStackView()
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

    internal let paymentStackView: CheckoutSummaryPaymentActionRowStackView = {
        let stackView = CheckoutSummaryPaymentActionRowStackView()
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
        setWidth(equalToView: superview)

        shippingAddressStackView.setHeight(equalToView: billingAddressStackView)
        shippingAddressStackView.setHeight(equalToView: paymentStackView)

        productSeparatorView.setHeight(equalToConstant: 10)
        shippingAddressSeparatorView.setHeight(equalToConstant: 1)
        billingAddressSeparatorView.setHeight(equalToConstant: 1)
        paymentSeparatorView.setHeight(equalToConstant: 1)
    }

    func builderSubviews() -> [UIBuilder] {
        return [productStackView, shippingAddressStackView, billingAddressStackView, paymentStackView, priceStackView]
    }

}

extension CheckoutSummaryMainStackView: UIDataBuilder {

    typealias T = CheckoutSummaryViewController

    func configureData(viewModel: T) {
        productStackView.configureData(viewModel)
        priceStackView.configureData(viewModel)
        priceStackView.hidden = !viewModel.viewState.showPrice

        let shippingAddress = viewModel.checkoutViewModel.shippingAddress(localizedWith: viewModel)
        let billingAddress = viewModel.checkoutViewModel.shippingAddress(localizedWith: viewModel)

        shippingAddressStackView.configureData(CheckoutSummaryAddressActionViewModel(
            title: viewModel.loc("Address.Shipping"),
            firstLineValue: shippingAddress[0].trimmed,
            secondLineValue: shippingAddress.count > 1 ? shippingAddress[1].trimmed : nil,
            showArrow: viewModel.viewState.showDetailArrow)
        )

        billingAddressStackView.configureData(CheckoutSummaryAddressActionViewModel(
            title: viewModel.loc("Address.Billing"),
            firstLineValue: billingAddress[0].trimmed,
            secondLineValue: billingAddress.count > 1 ? billingAddress[1].trimmed : nil,
            showArrow: viewModel.viewState.showDetailArrow)
        )

        paymentStackView.configureData(CheckoutSummaryPaymentActionViewModel(
            title: viewModel.loc("Payment"),
            value: viewModel.checkoutViewModel.selectedPaymentMethod ?? "",
            showArrow: viewModel.viewState.showDetailArrow)
        )
    }

}
