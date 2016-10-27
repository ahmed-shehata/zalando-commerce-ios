//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK
import AtlasUI

class CatalogViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var productCollectionView: UICollectionView!

    var articles = [DemoArticle]() {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.productCollectionView.reloadData()
            }
        }
    }

    private let articlesClient = ArticlesClient()
    private let sampleSKUs = [
        "L2711E002-Q11", "AZ711N007-Q11", "AZ711N008-G11",
        "GU121D08Z-Q11", "AZ711N007-Q11", "MA322E020-E11",
        "AZ711M001-B11", "AZ711N00B-Q11", "MK151F00E-Q11",
        "AR322O01B-I11", "M0Q21C068-B11", "UG151B002-C11",
        "EV451D00U-302", "TP822C00N-Q11", "RA252F005-802",
        "AJ152H012-Q11", "6CA51L00B-D11", "C1551E00K-F11",
        "PS752G001-Q11", "PX652G005-K11"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        self.navigationController?.navigationBar.accessibilityIdentifier = "catalog-navigation-controller"
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadHomepageArticles()
    }

    private func loadHomepageArticles() {
        articlesClient.fetch(articlesForSKUs: sampleSKUs) { result in
            switch result {
            case .success(let articles):
                self.articles = articles
            case .failure(let error):
                self.showError(title: "Error", error: error)
            }
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductCollectionViewCell", forIndexPath: indexPath)
        guard let productCell = cell as? ProductCollectionViewCell else {
            return cell
        }

        return productCell.setupCell(withArticle: articles[indexPath.row])
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }

}
