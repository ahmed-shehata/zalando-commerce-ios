//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

enum CheckoutSummaryArticleSelectCollectionViewType {

    case size
    case quantity

}

class CheckoutSummaryArticleSelectCollectionView: UICollectionView {

    var selectedArticle: SelectedArticle?
    var type: CheckoutSummaryArticleSelectCollectionViewType?

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7
        layout.sectionInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        layout.itemSize = CGSize(width: 90, height: 36)
        layout.scrollDirection = .horizontal

        super.init(frame: .zero, collectionViewLayout: layout)
        showsHorizontalScrollIndicator = false
        dataSource = self
        delegate = self
        register(CheckoutSummaryArticleSelectCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with selectedArticle: SelectedArticle, for type: CheckoutSummaryArticleSelectCollectionViewType) {
        self.selectedArticle = selectedArticle
        self.type = type
        reloadData()
    }

}

extension CheckoutSummaryArticleSelectCollectionView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let type = type, let selectedArticle = selectedArticle else { return 0 }
        switch type {
        case .size: return selectedArticle.article.availableUnits.count
        case .quantity: return selectedArticle.unit.stock
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard
            let type = type,
            let selectedArticle = selectedArticle,
            let selectCell = cell as? CheckoutSummaryArticleSelectCollectionViewCell else { return cell }

        selectCell.buildView()
        selectCell.configure(selectedArticle: selectedArticle, type: type, idx: indexPath.row)
        return selectCell
    }

}

extension CheckoutSummaryArticleSelectCollectionView: UICollectionViewDelegate {

}
