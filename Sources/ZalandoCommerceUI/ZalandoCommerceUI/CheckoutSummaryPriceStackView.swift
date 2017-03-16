//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryPriceStackView: UIStackView {

    let shippingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    let shippingTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .left
        return label
    }()

    let shippingValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .right
        return label
    }()

    let subtotalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isHidden = true
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    let subtotalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .left
        return label
    }()

    let subtotalValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .right
        return label
    }()

    let discountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isHidden = true
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    let discountTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .orange
        label.textAlignment = .left
        return label
    }()

    let discountValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .orange
        label.textAlignment = .right
        return label
    }()

    let dummySeparatorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 4)
        label.text = " "
        return label
    }()

    let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    let totalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    let totalValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()

    let vatTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .right
        return label
    }()

}

extension CheckoutSummaryPriceStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(subtotalStackView)
        addArrangedSubview(shippingStackView)
        addArrangedSubview(discountStackView)
        addArrangedSubview(dummySeparatorLabel)
        addArrangedSubview(totalStackView)
        addArrangedSubview(vatTitleLabel)

        subtotalStackView.addArrangedSubview(subtotalTitleLabel)
        subtotalStackView.addArrangedSubview(subtotalValueLabel)

        shippingStackView.addArrangedSubview(shippingTitleLabel)
        shippingStackView.addArrangedSubview(shippingValueLabel)

        discountStackView.addArrangedSubview(discountTitleLabel)
        discountStackView.addArrangedSubview(discountValueLabel)

        totalStackView.addArrangedSubview(totalTitleLabel)
        totalStackView.addArrangedSubview(totalValueLabel)
    }

}

extension CheckoutSummaryPriceStackView: UIDataBuilder {

    typealias T = CheckoutSummaryDataModel

    func configure(viewModel: T) {
        shippingTitleLabel.text = Localizer.format(string: "summaryView.label.price.shipping")
        subtotalTitleLabel.text = Localizer.format(string: "summaryView.label.price.subtotal")
        discountTitleLabel.text = Localizer.format(string: "summaryView.label.price.discount")
        totalTitleLabel.text = Localizer.format(string: "summaryView.label.price.total")
        vatTitleLabel.text = Localizer.format(string: "summaryView.label.price.vat")

        if let discount = viewModel.discount {
            subtotalValueLabel.text = Localizer.format(price: viewModel.subtotal)
            discountValueLabel.text = Localizer.format(price: discount.grossTotal)
        }

        let hideDiscount = viewModel.discount == nil
        UIView.animate(duration: .normal) { [weak self] in
            self?.shippingTitleLabel.font = .systemFont(ofSize: hideDiscount ? 14 : 10, weight: UIFontWeightLight)
            self?.shippingValueLabel.font = .systemFont(ofSize: hideDiscount ? 14 : 10, weight: UIFontWeightLight)
            self?.subtotalStackView.isHidden = hideDiscount
            self?.discountStackView.isHidden = hideDiscount
        }

        if viewModel.selectedArticle.isSelected {
            shippingValueLabel.text = Localizer.format(price: viewModel.shippingPrice)
            totalValueLabel.text = Localizer.format(price: viewModel.totalPrice)
        } else {
            shippingValueLabel.text = "-"
            totalValueLabel.text = "-"
        }
    }

}
