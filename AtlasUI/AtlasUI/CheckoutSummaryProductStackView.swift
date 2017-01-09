//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class CheckoutSummaryProductStackView: UIStackView {

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

    let unitSizeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = .lightGray
        return label
    }()

    let unitColorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = .lightGray
        return label
    }()

}

extension CheckoutSummaryProductStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(articleImageView)
        addArrangedSubview(detailsStackView)

        detailsStackView.addArrangedSubview(brandNameLabel)
        detailsStackView.addArrangedSubview(articleNameLabel)
        detailsStackView.addArrangedSubview(unitSizeLabel)
        detailsStackView.addArrangedSubview(unitColorLabel)
    }

    func configureConstraints() {
        articleImageView.setSquareAspectRatio()
        articleImageView.setWidth(equalToView: superview, multiplier: 0.2)
    }

}

extension CheckoutSummaryProductStackView: UIDataBuilder {

    typealias T = SelectedArticleUnit

    func configure(viewModel: T) {
        articleImageView.setImage(from: viewModel.article.thumbnailURL)
        brandNameLabel.text = viewModel.article.brand.name
        articleNameLabel.text = viewModel.article.name
        unitSizeLabel.text = Localizer.format(string: "summaryView.label.unitSize", viewModel.unit.size)
        unitColorLabel.text = viewModel.article.color
    }

}
