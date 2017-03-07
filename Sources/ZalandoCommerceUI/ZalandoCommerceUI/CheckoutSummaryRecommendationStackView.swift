//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import ZalandoCommerceAPI

class CheckoutSummaryRecommendationStackView: UIStackView {

    let recommendationSeparatorView: BorderView = {
        let view = BorderView()
        view.topBorder = true
        view.borderColor = UIColor(hex: 0xB2B2B2)
        return view
    }()

    let loaderContrainer = UIView()

    let innerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()

    let recommendationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = .black
        label.textAlignment = .center
        label.text = Localizer.format(string: "recommendation.title")
        label.numberOfLines = 1
        label.alpha = 0
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
        addArrangedSubview(loaderContrainer)
        loaderContrainer.addSubview(innerStackView)
        innerStackView.addArrangedSubview(recommendationTitleLabel)
        innerStackView.addArrangedSubview(recommendationCollectionView)
    }

    func configureConstraints() {
        recommendationSeparatorView.setHeight(equalToConstant: 1)
        recommendationCollectionView.setHeight(equalToConstant: 70)
        innerStackView.fillInSuperview()
    }

}

extension CheckoutSummaryRecommendationStackView: UIDataBuilder {

    typealias T = Article

    func configure(viewModel: T) {
        AtlasAPI.withLoader.recommendations(for: viewModel.id, onView: loaderContrainer) { [weak self] result in
            guard let recommendations = result.process() else { return }
            self?.recommendationTitleLabel.alpha = 1
            self?.recommendationCollectionView.configure(with: recommendations, completion: { recommendation in
                if let reason = ZalandoCommerceUIViewController.presented?.dismissalReason,
                    case let .orderPlaced(orderConfirmation, _) = reason {
                        let recommendationReason = ZalandoCommerceUI.CheckoutResult.orderPlaced(orderConfirmation: orderConfirmation,
                                                                                                customerRequestedArticle: recommendation.id)
                        ZalandoCommerceUIViewController.presented?.dismissalReason = recommendationReason
                        try? ZalandoCommerceUIViewController.presented?.dismissAtlasCheckoutUI()
                }
            })
        }
    }

}
