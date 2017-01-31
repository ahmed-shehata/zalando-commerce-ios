//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryRootStackView: UIStackView {

    let productStackView: CheckoutSummaryProductStackView = {
        let stackView = CheckoutSummaryProductStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()

    let checkoutContainer: CheckoutContainerView = {
        let view = CheckoutContainerView()
        view.backgroundColor = .clear
        return view
    }()

}

extension CheckoutSummaryRootStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(productStackView)
        addArrangedSubview(checkoutContainer)
    }

    func configureConstraints() {
        fillInSuperview()
    }

}

extension CheckoutSummaryRootStackView: UIDataBuilder {

    typealias T = CheckoutSummaryViewModel

    func configure(viewModel: T) {
        productStackView.configure(viewModel: viewModel.dataModel.selectedArticle)
        checkoutContainer.configure(viewModel: viewModel)
    }

}
