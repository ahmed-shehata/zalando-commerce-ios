//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

final class SizeSelectionViewController: UIViewController {

    private let sku: String
    private let checkoutService = CheckoutService()

    init(sku: String) {
        self.sku = sku
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pick a size".loc
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

    private func showCheckoutScreen(article: Article, selectedUnitIndex: Int, animated: Bool) {
        AtlasSDK.fetchCustomer { result in
            switch result {
            case .failure(let error):
                AtlasLogger.logError(error)
                UserMessage.showError(title: "Error".loc, error: error)
            case .success(let customer):
                self.generateCheckout(withArticle: article, customer: customer, animated: animated)
            }
        }
    }

    private func generateCheckout(withArticle article: Article, customer: Customer, animated: Bool) {
        checkoutService.generateCheckout(withArticle: article,
            articleUnitIndex: 0) { (result) in
                switch result {
                case .failure(let error):
                    AtlasLogger.logError(error)
                    self.dismissViewControllerAnimated(true) {
                        UserMessage.showError(title: "Fatal Error".loc, error: error)
                    }
                case .success(let checkout):
                    let checkoutSummaryVC = CheckoutSummaryViewController(customer: customer, checkoutView: checkout)
                    if animated {
                        self.showViewController(checkoutSummaryVC, sender: self)
                    } else {
                        UIView.performWithoutAnimation {
                            self.showViewController(checkoutSummaryVC, sender: self)
                        }
                    }
                }
        }
    }

    private func fetchSizes() {
        activityIndicatorView.startAnimating()
        AtlasSDK.fetchArticle(sku: sku) { [weak self] result in
            guard let strongSelf = self else { return }
            Async.main {
                switch result {
                case .failure(let error):
                    UserMessage.showError(title: "Fatal Error".loc, error: error)
                case .success(let article):
                    strongSelf.displaySizes(forArticle: article)
                }
            }
        }
    }

    private func displaySizes(forArticle article: Article) {
        if article.hasSingleUnit {
            showCheckoutScreen(article, selectedUnitIndex: 0, animated: false)
        } else {
            Async.main {
                self.activityIndicatorView.stopAnimating()
            }
            self.showSizeListViewController(article)
        }

    }

    private func showSizeListViewController(article: Article) {
        let sizeListSelectionViewController = SizeListSelectionViewController(article: article)
        addChildViewController(sizeListSelectionViewController)
        sizeListSelectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sizeListSelectionViewController.view)
        sizeListSelectionViewController.view.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true
        sizeListSelectionViewController.view.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        sizeListSelectionViewController.view.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        sizeListSelectionViewController.view.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor).active = true
        sizeListSelectionViewController.didMoveToParentViewController(self)
    }
}
