//
//  CheckoutSummaryActionRowStackView.swift
//  AtlasUI
//
//  Created by Hani Ibrahim Ibrahim Eloksh on 01/09/16.
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryActionRowStackView: UIStackView {

    internal let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Horizontal
        stackView.distribution = .FillEqually
        stackView.spacing = 10
        return stackView
    }()

    internal let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFontOfSize(16)
        label.textColor = .blackColor()
        return label
    }()

    internal let valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = UIColor(netHex: 0x7F7F7F)
        return label
    }()

    internal let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "tableArrow", bundledWith: CheckoutSummaryActionRowStackView.self))
        imageView.contentMode = .Center
        return imageView
    }()

}

extension CheckoutSummaryActionRowStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(labelsStackView)
        addArrangedSubview(arrowImageView)

        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(valueLabel)
    }

    func configureConstraints() {
        arrowImageView.setWidthToConstant(20)
    }

}
