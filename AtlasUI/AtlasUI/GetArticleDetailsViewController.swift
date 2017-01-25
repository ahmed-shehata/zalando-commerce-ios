//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class GetArticleDetailsViewController: UIViewController {

    let sku: String

    init(sku: String) {
        self.sku = sku
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        getArticle()
    }

    private func getArticle() {
        AtlasUIClient.article(withSKU: self.sku) { [weak self] result in
            guard let article = result.process(forceFullScreenError: true) else { return }
            self?.showArticleSelectionView(article: article)
        }
    }

    private func showArticleSelectionView(article: Article) {
        let articleSelectionViewController = ArticleSelectionViewController(article: article)
        AtlasUIViewController.shared?.mainNavigationController.viewControllers = [articleSelectionViewController]
    }

}
