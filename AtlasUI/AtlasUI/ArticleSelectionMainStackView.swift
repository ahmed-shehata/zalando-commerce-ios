//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class ArticleSelectionMainStackView: UIStackView {

    let productStackView: ArticleSelectionProductStackView = {
        let stackView = ArticleSelectionProductStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let productSeparatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.borderColor = UIColor(hex: 0xE5E5E5)
        return view
    }()

    let quantityStackView: ArticleSelectionQuantityStackView = {
        let stackView = ArticleSelectionQuantityStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 40)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let quantitySeparatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.borderColor = UIColor(hex: 0xE5E5E5)
        return view
    }()

    let sizeStackView: ArticleSelectionSizeStackView = {
        let stackView = ArticleSelectionSizeStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let sizeSeparatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.borderColor = UIColor(hex: 0xE5E5E5)
        return view
    }()

    let priceStackView: ArticleSelectionPriceStackView = {
        let stackView = ArticleSelectionPriceStackView()
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

}

extension ArticleSelectionMainStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(productStackView)
        addArrangedSubview(productSeparatorView)
        addArrangedSubview(quantityStackView)
        addArrangedSubview(quantitySeparatorView)
        addArrangedSubview(sizeStackView)
        addArrangedSubview(sizeSeparatorView)
        addArrangedSubview(priceStackView)

        productSeparatorView.setHeight(equalToConstant: 10)
        quantitySeparatorView.setHeight(equalToConstant: 1)
        sizeSeparatorView.setHeight(equalToConstant: 1)
    }

    func configureConstraints() {
        fillInSuperview()
        setWidth(equalToView: superview)

        quantityStackView.setHeight(equalToConstant: 50)
        sizeStackView.setHeight(equalToConstant: 50)
    }

}

extension ArticleSelectionMainStackView: UIDataBuilder {

    typealias T = SelectedArticle

    func configure(viewModel: SelectedArticle) {
        productStackView.configure(viewModel: viewModel)
        quantityStackView.configure(viewModel: ArticleSelectionQuantityViewModel(currentValue: viewModel.quantity,
                                                                                 maximumValue: viewModel.unit.stock))
        sizeStackView.configure(viewModel: ArticleSelectionSizeViewModel(value: viewModel.unit.size,
                                                                         showArrow: !viewModel.article.hasSingleUnit))

        let totalPrice = viewModel.unit.price.amount.multiplying(by: NSDecimalNumber(integerLiteral: viewModel.quantity))
        priceStackView.configure(viewModel: ArticleSelectionPriceViewModel(itemPrice: viewModel.unit.price,
                                                                           totalPrice: Money(amount: totalPrice,
                                                                                             currency: viewModel.unit.price.currency)))
    }

}
