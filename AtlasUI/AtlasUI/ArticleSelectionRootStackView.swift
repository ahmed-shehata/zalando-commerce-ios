//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class ArticleSelectionRootStackView: UIStackView {

    let scrollView: UIScrollView = UIScrollView()

    let mainStackView: ArticleSelectionMainStackView = {
        let stackView = ArticleSelectionMainStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let footerStackView: ArticleSelectionFooterStackView = {
        let stackView = ArticleSelectionFooterStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

}

extension ArticleSelectionRootStackView: UIBuilder {

    func configureView() {
        scrollView.addSubview(mainStackView)
        addArrangedSubview(scrollView)
        addArrangedSubview(footerStackView)
    }

    func configureConstraints() {
        fillInSuperview()
    }

}

extension ArticleSelectionRootStackView: UIDataBuilder {

    typealias T = SelectedArticle

    func configure(viewModel: SelectedArticle) {

    }

}
