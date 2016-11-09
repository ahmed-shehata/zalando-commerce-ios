//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryRootStackView: UIStackView {

    internal let scrollView = UIScrollView()

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
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
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

}

extension CheckoutSummaryRootStackView: UIDataBuilder {

    typealias T = CheckoutSummaryViewController // TODO: Create new view model

    func configureData(viewModel: T) {
        mainStackView.configureData(viewModel)
        footerStackView.configureData(viewModel)
    }

}
