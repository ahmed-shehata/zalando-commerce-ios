//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class ArticleSelectionProductStackView: UIStackView {

    let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillProportionally
        return stackView
    }()

    let brandNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: UIFontWeightBold)
        label.textColor = .black
        return label
    }()

    let articleNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = .black
        return label
    }()

}

extension ArticleSelectionProductStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(articleImageView)
        addArrangedSubview(detailsStackView)

        detailsStackView.addArrangedSubview(brandNameLabel)
        detailsStackView.addArrangedSubview(articleNameLabel)
    }

    func configureConstraints() {
        articleImageView.setSquareAspectRatio()
        articleImageView.setWidth(equalToView: superview, multiplier: 0.2)
    }

}

extension ArticleSelectionProductStackView: UIDataBuilder {

    typealias T = SelectedArticle

    func configure(viewModel: SelectedArticle) {
        articleImageView.setImage(from: viewModel.article.thumbnailURL)
        brandNameLabel.text = viewModel.article.brand.name
        articleNameLabel.text = viewModel.article.name
    }

}
