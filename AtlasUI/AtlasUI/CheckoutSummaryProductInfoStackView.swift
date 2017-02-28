//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class CheckoutSummaryProductInfoStackView: UIStackView {

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

    let unitDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()

    let unitColorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x848484)
        return label
    }()

    let unitPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: UIFontWeightLight)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()

}

extension CheckoutSummaryProductInfoStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(articleImageView)
        addArrangedSubview(detailsStackView)

        detailsStackView.addArrangedSubview(brandNameLabel)
        detailsStackView.addArrangedSubview(articleNameLabel)
        detailsStackView.addArrangedSubview(unitDetailsStackView)

        unitDetailsStackView.addArrangedSubview(unitColorLabel)
        unitDetailsStackView.addArrangedSubview(unitPriceLabel)
    }

    func configureConstraints() {
        articleImageView.setSquareAspectRatio()
        articleImageView.setWidth(equalToView: superview, multiplier: 0.2)
    }

}

extension CheckoutSummaryProductInfoStackView: UIDataBuilder {

    typealias T = SelectedArticle

    func configure(viewModel: T) {
        articleImageView.setImage(from: viewModel.article.thumbnailURL)
        brandNameLabel.text = viewModel.article.brand.name
        articleNameLabel.text = viewModel.article.name
        unitColorLabel.text = viewModel.article.color
        if viewModel.isSelected {
            unitPriceLabel.text = Localizer.format(price: viewModel.unit.price)
        } else {
            unitPriceLabel.text = ""
        }
    }

}
