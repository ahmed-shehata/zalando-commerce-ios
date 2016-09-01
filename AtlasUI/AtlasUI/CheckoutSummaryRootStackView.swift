//
//  CheckoutSummaryRootStackView.swift
//  AtlasUI
//
//  Created by Hani Ibrahim Ibrahim Eloksh on 01/09/16.
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryRootStackView: UIStackView {

    internal let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    internal let mainStackView: CheckoutSummaryMainStackView = {
        let stackView = CheckoutSummaryMainStackView()
        stackView.axis = .Vertical
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    internal let footerStackView: CheckoutSummaryFooterStackView = {
        let stackView = CheckoutSummaryFooterStackView()
        stackView.axis = .Vertical
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

}

extension CheckoutSummaryRootStackView: UIBuilder {

    func configureView() {
        scrollView.addSubview(mainStackView)
        addArrangedSubview(scrollView)
        addArrangedSubview(footerStackView)
    }

    func configureConstraints() {
        fillInSuperView()
    }

    func builderSubViews() -> [UIBuilder] {
        return [mainStackView, footerStackView]
    }

}
