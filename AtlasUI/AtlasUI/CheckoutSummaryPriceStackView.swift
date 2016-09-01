//
//  CheckoutSummaryPriceStackView.swift
//  AtlasUI
//
//  Created by Hani Ibrahim Ibrahim Eloksh on 01/09/16.
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryPriceStackView: UIStackView {

    internal let shippingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Horizontal
        stackView.distribution = .FillEqually
        return stackView
    }()

    internal let shippingTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = UIColor(netHex: 0x7F7F7F)
        label.textAlignment = .Right
        return label
    }()

    internal let shippingValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = UIColor(netHex: 0x7F7F7F)
        label.textAlignment = .Right
        return label
    }()

    private let dummySeparatorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(4)
        label.text = " "
        return label
    }()

    internal let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Horizontal
        stackView.distribution = .FillEqually
        return stackView
    }()

    internal let totalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(16)
        label.textColor = .blackColor()
        label.textAlignment = .Right
        return label
    }()

    internal let totalValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(16)
        label.textColor = .blackColor()
        label.textAlignment = .Right
        return label
    }()
}

extension CheckoutSummaryPriceStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(shippingStackView)
        addArrangedSubview(dummySeparatorLabel)
        addArrangedSubview(totalStackView)

        shippingStackView.addArrangedSubview(shippingTitleLabel)
        shippingStackView.addArrangedSubview(shippingValueLabel)

        totalStackView.addArrangedSubview(totalTitleLabel)
        totalStackView.addArrangedSubview(totalValueLabel)
    }

}
