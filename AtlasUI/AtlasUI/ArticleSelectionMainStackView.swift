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

}

extension ArticleSelectionMainStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(productStackView)
        addArrangedSubview(productSeparatorView)

        productSeparatorView.setHeight(equalToConstant: 10)
    }

    func configureConstraints() {
        fillInSuperview()
        setWidth(equalToView: superview)
    }

}

extension ArticleSelectionMainStackView: UIDataBuilder {

    typealias T = SelectedArticle

    func configure(viewModel: SelectedArticle) {
        productStackView.configure(viewModel: viewModel)
    }

}
