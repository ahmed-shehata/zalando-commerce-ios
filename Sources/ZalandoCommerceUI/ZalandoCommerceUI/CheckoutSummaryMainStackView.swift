//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryMainStackView: UIStackView {

    let orderStackView: CheckoutSummaryOrderStackView = {
        let stackView = CheckoutSummaryOrderStackView()
        stackView.isHidden = true
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let shippingAddressStackView: CheckoutSummaryAddressStackView = {
        let stackView = CheckoutSummaryAddressStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.accessibilityIdentifier = "shipping-stack-view"
        stackView.setTitle(fromLocalizedKey: "summaryView.label.address.shipping")
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
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.accessibilityIdentifier = "billing-stack-view"
        stackView.setTitle(fromLocalizedKey: "summaryView.label.address.billing")
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
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.setTitle(fromLocalizedKey: "summaryView.label.payment")
        return stackView
    }()

    let couponSeparatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.leadingMargin = 15
        view.borderColor = UIColor(hex: 0xE5E5E5)
        return view
    }()

    let couponStackView: CheckoutSummaryCouponStackView = {
        let stackView = CheckoutSummaryCouponStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let fullSeparatorView: BorderView = {
        let view = BorderView()
        view.topBorder = true
        view.borderColor = UIColor(hex: 0xE5E5E5)
        return view
    }()

    let guestStackView: CheckoutSummaryGuestStackView = {
        let stackView = CheckoutSummaryGuestStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let priceStackView: CheckoutSummaryPriceStackView = {
        let stackView = CheckoutSummaryPriceStackView()
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let deliveryStackView: CheckoutSummaryDeliveryStackView = {
        let stackView = CheckoutSummaryDeliveryStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    var couponHeightConstraint: NSLayoutConstraint?

}

extension CheckoutSummaryMainStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(orderStackView)

        addArrangedSubview(shippingAddressStackView)
        addArrangedSubview(shippingAddressSeparatorView)

        addArrangedSubview(billingAddressStackView)
        addArrangedSubview(billingAddressSeparatorView)
        addArrangedSubview(paymentStackView)

        addArrangedSubview(fullSeparatorView)
        addArrangedSubview(guestStackView)
        addArrangedSubview(priceStackView)
        addArrangedSubview(deliveryStackView)
    }

    func configureConstraints() {
        fillInSuperview()
        setWidth(equalToView: superview)

        paymentStackView.setHeight(equalToView: billingAddressStackView)
        paymentStackView.setHeight(equalToView: shippingAddressStackView)

        shippingAddressSeparatorView.setHeight(equalToConstant: 1)
        billingAddressSeparatorView.setHeight(equalToConstant: 1)
        couponSeparatorView.setHeight(equalToConstant: 1)
        fullSeparatorView.setHeight(equalToConstant: 3)
    }

}

extension CheckoutSummaryMainStackView: UIDataBuilder {

    typealias T = CheckoutSummaryViewModel

    func configure(viewModel: T) {
        priceStackView.configure(viewModel: viewModel.dataModel)
        deliveryStackView.configure(viewModel: viewModel.dataModel)
        guestStackView.configure(viewModel: viewModel.dataModel.email)
        guestStackView.isHidden = !viewModel.layout.showsGuestStackView

        if viewModel.layout.showsCouponStackView {
            insertArrangedSubview(couponSeparatorView, at: 6)
            insertArrangedSubview(couponStackView, at: 7)
            couponStackView.buildView()
            couponHeightConstraint = paymentStackView.setHeight(equalToView: couponStackView)
        } else if let constraint = couponHeightConstraint {
            paymentStackView.removeConstraint(constraint)
            removeArrangedSubview(couponStackView)
            removeArrangedSubview(couponSeparatorView)
        }

        if viewModel.layout.showsOrderStackView {
            orderStackView.configure(viewModel: viewModel.dataModel.orderNumber)
            UIView.animate(duration: .normal) { [weak self] in
                self?.orderStackView.isHidden = false
            }
        }

        shippingAddressStackView.configure(viewModel: CheckoutSummaryAddressViewModel(
            addressLines: viewModel.dataModel.formattedShippingAddress,
            showArrow: viewModel.layout.showsDetailArrow)
        )

        billingAddressStackView.configure(viewModel: CheckoutSummaryAddressViewModel(
            addressLines: viewModel.dataModel.formattedBillingAddress,
            showArrow: viewModel.layout.showsDetailArrow)
        )

        paymentStackView.configure(viewModel: CheckoutSummaryPaymentViewModel(
            value: viewModel.dataModel.paymentMethod ?? "",
            showArrow: viewModel.layout.showsDetailArrow)
        )
    }

}
