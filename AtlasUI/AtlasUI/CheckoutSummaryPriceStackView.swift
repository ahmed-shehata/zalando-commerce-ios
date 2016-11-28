//
//  Copyright © 2016 Zalando SE. All rights reserved.
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

    fileprivate let dummySeparatorLabel: UILabel = {
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
        addArrangedSubview(shippingStackView)
        addArrangedSubview(dummySeparatorLabel)
        addArrangedSubview(totalStackView)
        addArrangedSubview(vatTitleLabel)

        shippingStackView.addArrangedSubview(shippingTitleLabel)
        shippingStackView.addArrangedSubview(shippingValueLabel)

        totalStackView.addArrangedSubview(totalTitleLabel)
        totalStackView.addArrangedSubview(totalValueLabel)
    }

}

extension CheckoutSummaryPriceStackView: UIDataBuilder {

    typealias T = CheckoutSummaryDataModel

    func configure(viewModel: T) {
        shippingTitleLabel.text = Localizer.format(string: "summaryView.label.price.shipping")
        shippingValueLabel.text = Localizer.format(price: viewModel.shippingPrice)
        totalTitleLabel.text = Localizer.format(string: "summaryView.label.price.total")
        totalValueLabel.text = Localizer.format(price: viewModel.totalPrice)
        vatTitleLabel.text = Localizer.format(string: "summaryView.label.price.vat")
    }

}
