//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

enum CheckoutSummaryArticleRefineType {

    case size
    case quantity

    func count(selectedArticle: SelectedArticle) -> Int {
        switch self {
        case .size: return selectedArticle.article.availableUnits.count
        case .quantity: return selectedArticle.unit.stock
        }
    }

    func idx(selectedArticle: SelectedArticle) -> Int {
        switch self {
        case .size: return selectedArticle.unitIndex
        case .quantity: return selectedArticle.quantity - 1
        }
    }

}

typealias CheckoutSummaryArticleRefineCompletion = (Int) -> Void

class CheckoutSummaryArticleSelectCollectionView: UICollectionView {

    var selectedArticle: SelectedArticle?
    var type: CheckoutSummaryArticleRefineType?
    var completion: CheckoutSummaryArticleRefineCompletion?

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

    func configure(with selectedArticle: SelectedArticle, for type: CheckoutSummaryArticleRefineType, animated: Bool) {
        self.selectedArticle = selectedArticle
        self.type = type
        guard animated else { return reload(andSelect: type.idx(selectedArticle: selectedArticle)) }

        UIView.animate(duration: .fast, animations: { [weak self] in
            self?.alpha = 0
        }, completion: { [weak self] _ in
            self?.reload(andSelect: type.idx(selectedArticle: selectedArticle))
            UIView.animate(duration: .fast) {
                self?.alpha = 1
            }
        })
    }

    private func reload(andSelect idx: Int) {
        reloadData()
        guard idx != NSNotFound && idx < numberOfItems(inSection: 0) else { return }
        selectItem(at: IndexPath(row: idx, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }

}

extension CheckoutSummaryArticleSelectCollectionView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let type = type, let selectedArticle = selectedArticle else { return 0 }
        return type.count(selectedArticle: selectedArticle)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard
            let type = type,
            let selectedArticle = selectedArticle,
            let selectCell = cell as? CheckoutSummaryArticleSelectCollectionViewCell else { return cell }

        selectCell.buildView()
        selectCell.configure(selectedArticle: selectedArticle, type: type, idx: indexPath.row)
        selectCell.accessibilityIdentifier = "size-cell-\(indexPath.row)"
        selectCell.accessibilityLabel = "size-cell-\(selectedArticle.article.availableUnits[indexPath.row].size)"
        return selectCell
    }

}

extension CheckoutSummaryArticleSelectCollectionView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        completion?(indexPath.row)
    }

}
