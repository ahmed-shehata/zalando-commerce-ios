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
            self?.showSummaryView(article: article)
        }
    }

    private func showSummaryView(article: Article) {
        let initialSelectedArticle = SelectedArticle(article: article, unitIndex: NSNotFound, quantity: 1)
        let dataModel = CheckoutSummaryDataModel(selectedArticle: initialSelectedArticle,
                                                 totalPrice: initialSelectedArticle.totalPrice)
        let viewModel = CheckoutSummaryViewModel(dataModel: dataModel, layout: ArticleNotSelectedLayout())
        let checkoutSummaryViewController = CheckoutSummaryViewController(viewModel: viewModel)
        checkoutSummaryViewController.actionHandler = ArticleNotSelectedActionHandler() // TODO: Support One size
        navigationController?.viewControllers = [checkoutSummaryViewController]
    }

}
