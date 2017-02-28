//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class CheckoutSummaryRecommendationCollectionViewCell: UICollectionViewCell {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillProportionally
        return stackView
    }()

    let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let articleNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: UIFontWeightLight)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: UIFontWeightRegular)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

}

extension CheckoutSummaryRecommendationCollectionViewCell: UIBuilder {

    func configureView() {
        addSubview(stackView)

        stackView.addArrangedSubview(articleImageView)
        stackView.addArrangedSubview(articleNameLabel)
        stackView.addArrangedSubview(priceLabel)
    }

    func configureConstraints() {
        stackView.fillInSuperview()
        articleImageView.setHeight(equalToConstant: 40)
        articleNameLabel.setHeight(equalToView: priceLabel)
    }

}

extension CheckoutSummaryRecommendationCollectionViewCell: UIDataBuilder {

    typealias T = Recommendation

    func configure(viewModel: Recommendation) {
        articleImageView.setImage(from: viewModel.media?.mediaItems.first?.catalogURL)
        articleNameLabel.text = viewModel.name
        priceLabel.text = Localizer.format(price: viewModel.lowestPrice)
    }

}
