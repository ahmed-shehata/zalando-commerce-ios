//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

final class SizeSelectionViewController: UIViewController, CheckoutProviderType {

    private let sku: String
    internal let checkout: AtlasCheckout

    init(checkout: AtlasCheckout, sku: String) {
        self.checkout = checkout
        self.sku = sku
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = loc("Pick a size")
        view.backgroundColor = UIColor.clearColor()
        view.opaque = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        activityIndicatorView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()

        fetchSizes()
    }

    private func showCheckoutScreen(article: Article, selectedUnitIndex: Int) {
        guard Atlas.isUserLoggedIn() else {
            let selectedArticleUnit = SelectedArticleUnit(article: article,
                selectedUnitIndex: 0)
            let checkoutViewModel = CheckoutViewModel(selectedArticleUnit: selectedArticleUnit)
            return displayCheckoutSummaryViewController(checkoutViewModel)
        }

        checkout.client.customer { result in

            guard let customer = result.success(errorHandlingType: .GeneralError(userMessage: self.userMessage)) else { return }
            self.generateCheckout(withArticle: article, customer: customer)
        }
    }

    private func generateCheckout(withArticle article: Article, customer: Customer) {
        let selectedArticleUnit = SelectedArticleUnit(article: article, selectedUnitIndex: 0)

        checkout.createCheckoutViewModel(for: selectedArticleUnit) { result in

            let errorType = AtlasUIError.CancelCheckout(userMessage: self.userMessage, viewController: self)
            guard var checkoutViewModel = result.success(errorHandlingType: errorType) else { return }

            checkoutViewModel.customer = customer
            self.displayCheckoutSummaryViewController(checkoutViewModel)
        }
    }

    private func displayCheckoutSummaryViewController(checkoutViewModel: CheckoutViewModel) {
        let checkoutSummaryVC = CheckoutSummaryViewController(checkout: checkout, checkoutViewModel: checkoutViewModel)

        UIView.performWithoutAnimation {
            self.showViewController(checkoutSummaryVC, sender: self)
        }

    }

    private func fetchSizes() {
        activityIndicatorView.startAnimating()

        checkout.client.article(forSKU: sku) { [weak self] result in
            guard let strongSelf = self else { return }

            guard let article = result.success(errorHandlingType: .GeneralError(userMessage: strongSelf.userMessage)) else { return }
            strongSelf.displaySizes(forArticle: article)
        }
    }

    private func displaySizes(forArticle article: Article) {
        guard !article.hasSingleUnit else {
            return showCheckoutScreen(article, selectedUnitIndex: 0)
        }
        self.activityIndicatorView.stopAnimating()
        self.showSizeListViewController(article)
    }

    private func showSizeListViewController(article: Article) {
        let sizeListSelectionViewController = SizeListSelectionViewController(checkout: checkout, article: article)
        addChildViewController(sizeListSelectionViewController)
        view.addSubview(sizeListSelectionViewController.view)

        sizeListSelectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        sizeListSelectionViewController.view.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true
        sizeListSelectionViewController.view.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        sizeListSelectionViewController.view.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        sizeListSelectionViewController.view.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor).active = true
        sizeListSelectionViewController.didMoveToParentViewController(self)
    }

}
