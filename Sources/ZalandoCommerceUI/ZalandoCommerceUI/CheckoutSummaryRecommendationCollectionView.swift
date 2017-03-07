//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import ZalandoCommerceAPI

typealias CheckoutSummaryRecommendationCompletion = (Recommendation) -> Void

class CheckoutSummaryRecommendationCollectionView: UICollectionView {

    var recommendations = [Recommendation]()
    var completion: CheckoutSummaryRecommendationCompletion?

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize = CGSize(width: 90, height: 70)
        layout.scrollDirection = .horizontal

        super.init(frame: .zero, collectionViewLayout: layout)
        showsHorizontalScrollIndicator = false
        dataSource = self
        delegate = self
        register(CheckoutSummaryRecommendationCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with recommendations: [Recommendation], completion: @escaping CheckoutSummaryRecommendationCompletion) {
        self.recommendations = recommendations
        self.completion = completion
        reloadData()
    }

}

extension CheckoutSummaryRecommendationCollectionView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard let recommendationCell = cell as? CheckoutSummaryRecommendationCollectionViewCell else { return cell }

        recommendationCell.buildView()
        recommendationCell.configure(viewModel: recommendations[indexPath.row])
        return recommendationCell
    }

}

extension CheckoutSummaryRecommendationCollectionView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        completion?(recommendations[indexPath.row])
    }

}
