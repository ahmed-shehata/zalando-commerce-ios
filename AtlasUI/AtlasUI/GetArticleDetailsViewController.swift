//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class GetArticleDetailsViewController: UIViewController {

    let sku: ConfigSKU

    init(sku: ConfigSKU) {
        self.sku = sku
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchArticle()
    }

    private func fetchArticle() {
        AtlasAPI.withLoader.article(with: self.sku) { [weak self] result in
            guard let article = result.process(presentationMode: .fullScreen) else { return }
            self?.showSummaryView(article: article)
        }
    }

    private func showSummaryView(article: Article) {
        guard article.hasSingleUnit else {
            let initialSelectedArticle = SelectedArticle.withoutUnit(article: article)
            let dataModel = CheckoutSummaryDataModel(selectedArticle: initialSelectedArticle, totalPrice: initialSelectedArticle.totalPrice)
            let viewModel = CheckoutSummaryViewModel(dataModel: dataModel, layout: ArticleNotSelectedLayout())
            showSummaryView(viewModel: viewModel, actionHandler: ArticleNotSelectedActionHandler())
            return
        }

        let selectedArticle = SelectedArticle(article: article)
        guard AtlasAPI.shared?.isAuthorized == true else {
            let dataModel = CheckoutSummaryDataModel(selectedArticle: selectedArticle, totalPrice: selectedArticle.totalPrice)
            let viewModel = CheckoutSummaryViewModel(dataModel: dataModel, layout: NotLoggedInLayout())
            showSummaryView(viewModel: viewModel, actionHandler: NotLoggedInSummaryActionHandler())
            return
        }

        AtlasAPI.withLoader.customer { [weak self] customerResult in
            guard let customer = customerResult.process(presentationMode: .fullScreen) else { return }

            LoggedInSummaryActionHandler.create(customer: customer, selectedArticle: selectedArticle) { actionHandlerResult in
                guard let actionHandler = actionHandlerResult.process(presentationMode: .fullScreen) else { return }

                let dataModel = CheckoutSummaryDataModel(selectedArticle: selectedArticle, cartCheckout: actionHandler.cartCheckout)
                let viewModel = CheckoutSummaryViewModel(dataModel: dataModel, layout: LoggedInLayout())
                self?.showSummaryView(viewModel: viewModel, actionHandler: actionHandler)
            }
        }
    }

    private func showSummaryView(viewModel: CheckoutSummaryViewModel, actionHandler: CheckoutSummaryActionHandler) {
        let checkoutSummaryViewController = CheckoutSummaryViewController(viewModel: viewModel)
        checkoutSummaryViewController.actionHandler = actionHandler
        navigationController?.viewControllers = [checkoutSummaryViewController]
    }

}
