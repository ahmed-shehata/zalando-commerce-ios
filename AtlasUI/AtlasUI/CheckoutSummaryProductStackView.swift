//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class CheckoutSummaryProductStackView: UIStackView {

    let productInfoStackView: CheckoutSummaryProductInfoStackView = {
        let stackView = CheckoutSummaryProductInfoStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let productInfoSeparatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.borderColor = UIColor(hex: 0xE5E5E5)
        return view
    }()

    let editArticleStackView: CheckoutSummaryEditProductStackView = {
        let stackView = CheckoutSummaryEditProductStackView()
        stackView.axis = .horizontal
        return stackView
    }()

    let editArticleSeparatorView: BorderView = {
        let view = BorderView()
        view.topBorder = true
        view.borderColor = UIColor(hex: 0xB2B2B2)
        return view
    }()

}

extension CheckoutSummaryProductStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(productInfoStackView)
        addArrangedSubview(productInfoSeparatorView)
        addArrangedSubview(editArticleStackView)
        addArrangedSubview(editArticleSeparatorView)
    }

    func configureConstraints() {
        productInfoSeparatorView.setHeight(equalToConstant: UIView.onePixel)
        editArticleSeparatorView.setHeight(equalToConstant: UIView.onePixel)
    }

}

extension CheckoutSummaryProductStackView: UIDataBuilder {

    typealias T = SelectedArticle

    func configure(viewModel: T) {
        productInfoStackView.configure(viewModel: viewModel)
        editArticleStackView.configure(viewModel: viewModel)
    }

}
