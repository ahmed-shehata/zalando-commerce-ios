//
//  CheckoutSummaryFooterStackView.swift
//  AtlasUI
//
//  Created by Hani Ibrahim Ibrahim Eloksh on 01/09/16.
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryFooterStackView: UIStackView {

    internal let footerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.font = .systemFontOfSize(12, weight: UIFontWeightLight)
        label.textColor = UIColor(netHex: 0xB2B2B2)
        return label
    }()

    internal let submitButton: RoundedButton = {
        let button = RoundedButton(type: .Custom)
        button.cornerRadius = 5
        button.titleLabel?.font = .systemFontOfSize(15)
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.backgroundColor = UIColor(netHex: 0x519415)
        return button
    }()

}

extension CheckoutSummaryFooterStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(footerLabel)
        addArrangedSubview(submitButton)
    }

}
