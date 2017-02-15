//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class CheckoutSummaryRecommendationStackView: UIStackView {

    let recommendationSeparatorView: BorderView = {
        let view = BorderView()
        view.topBorder = true
        view.borderColor = UIColor(hex: 0xE5E5E5)
        return view
    }()

    let recommendationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = .black
        label.textAlignment = .center
        label.text = Localizer.format(string: "recommendation.title")
        label.numberOfLines = 1
        return label
    }()

    let recommendationCollectionView: CheckoutSummaryRecommendationCollectionView = {
        let collectionView = CheckoutSummaryRecommendationCollectionView()
        collectionView.backgroundColor = .white
        return collectionView
    }()

}

extension CheckoutSummaryRecommendationStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(recommendationSeparatorView)
        addArrangedSubview(recommendationTitleLabel)
        addArrangedSubview(recommendationCollectionView)
    }

    func configureConstraints() {
        recommendationSeparatorView.setHeight(equalToConstant: 1)
        recommendationCollectionView.setHeight(equalToConstant: 70)
    }

}

extension CheckoutSummaryRecommendationStackView: UIDataBuilder {

    typealias T = Article

    func configure(viewModel: T) {
        AtlasUIClient.articleRecommendation(withSKU: viewModel.id) { [weak self] result in
            guard let recommendations = result.process() else { return }
            self?.recommendationCollectionView.configure(with: recommendations, completion: { recommendation in

            })
        }
    }

}
