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
            DispatchQueue.main.async {
                self.productCollectionView.reloadData()
            }
        }
    }

    fileprivate let articlesClient = ArticlesClient()
    fileprivate let sampleSKUs = [
        "L2711E002-Q11", "GU121D08Z-Q11", "AZ711M001-B11",
        "AZ711N00B-Q11", "MK151F00E-Q11", "M0Q21C068-B11",
        "EV451D00U-302", "RA252F005-802"
    ]

    static var shared: CatalogViewController? {
        guard let
            navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController,
            let catalogViewController = navigationController.viewControllers.first as? CatalogViewController
            else { return nil }
        return catalogViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        self.navigationController?.navigationBar.accessibilityIdentifier = "catalog-navigation-controller"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AppSetup.isConfigured {
            loadHomepageArticles()
        }
    }

    func loadHomepageArticles() {
        articlesClient.fetch(articlesForSKUs: sampleSKUs) { result in
            let processedResult = result.processedResult()
            switch processedResult {
            case .success(let articles): self.articles = articles.sorted { $0.id < $1.id }
            case .error(_, let title, let message): UIAlertController.showMessage(title: title, message: message)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath)
        guard let productCell = cell as? ProductCollectionViewCell else {
            return cell
        }

        return productCell.setupCell(withArticle: articles[indexPath.row])
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }

}
