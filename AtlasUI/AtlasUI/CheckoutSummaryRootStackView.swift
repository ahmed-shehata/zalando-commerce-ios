//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryRootStackView: UIStackView {

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()

    let mainStackView: CheckoutSummaryMainStackView = {
        let stackView = CheckoutSummaryMainStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let footerStackView: CheckoutSummaryFooterStackView = {
        let stackView = CheckoutSummaryFooterStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
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
        fillInSuperview()
    }

}

extension CheckoutSummaryRootStackView: UIDataBuilder {

    typealias T = CheckoutSummaryViewModel

    func configure(viewModel: T) {
        mainStackView.configure(viewModel: viewModel)
        footerStackView.configure(viewModel: viewModel)
    }

}
