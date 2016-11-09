//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryProductStackView: UIStackView {

    let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()

    let detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.spacing = 2
        stackView.distribution = .FillProportionally
        return stackView
    }()

    let brandNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(16, weight: UIFontWeightBold)
        label.textColor = .blackColor()
        return label
    }()

    let articleNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = .blackColor()
        return label
    }()

    let unitSizeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = .lightGrayColor()
        return label
    }()

    let unitColorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = .lightGrayColor()
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

    typealias T = CheckoutViewModel

    func configureData(viewModel: T) {
        articleImageView.setImage(fromUrl: viewModel.selectedArticleUnit.article.thumbnailURL)
        brandNameLabel.text = viewModel.selectedArticleUnit.article.brand.name
        articleNameLabel.text = viewModel.selectedArticleUnit.article.name
        unitSizeLabel.text = Localizer.string("summaryView.label.unitSize", viewModel.selectedArticleUnit.unit.size)
        unitColorLabel.text = viewModel.selectedArticleUnit.article.color
    }

}
