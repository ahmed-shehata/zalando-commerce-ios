//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

final class SizeListSelectionViewController: UITableViewController, CheckoutProviderType {

    private let article: Article
    internal let checkout: AtlasCheckout

    init(checkout: AtlasCheckout, article: Article) {
        self.checkout = checkout
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerReusableCell(UITableViewCell.self)
        view.backgroundColor = UIColor.clearColor()
        view.opaque = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        tableView.userInteractionEnabled = true
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return article.units.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(UITableViewCell.self, forIndexPath: indexPath) { result in
            switch result {
            case .dequeuedCell(let cell):
                let unit = self.article.units[indexPath.item]
                cell.textLabel?.text = unit.size
                cell.backgroundColor = UIColor.clearColor()
                cell.opaque = false
                cell.accessoryView = nil
                return cell
            case .defaultCell(let cell):
                return cell
            }

        }
    }

    internal override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) else { return }

        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        cell.accessoryView = spinner
        spinner.startAnimating()
        tableView.userInteractionEnabled = false

        guard Atlas.isUserLoggedIn() else {
            let checkoutViewModel = CheckoutViewModel(article: self.article, selectedUnitIndex: indexPath.row)
            displayCheckoutSummaryViewController(checkoutViewModel)
            spinner.stopAnimating()
            return
        }

        self.checkout.client.customer { result in
            switch result {
            case .failure(let error):
                self.userMessage.show(error: error)

            case .success(let customer):
                self.checkout.createCheckoutViewModel(withArticle: self.article, selectedUnitIndex: indexPath.row) { result in
                    spinner.stopAnimating()
                    switch result {
                    case .failure(let error):
                        self.dismissViewControllerAnimated(true) {
                            self.userMessage.show(error: error)
                        }
                    case .success(var checkoutViewModel):
                        checkoutViewModel.customer = customer
                        self.displayCheckoutSummaryViewController(checkoutViewModel)
                    }
                }
            }
        }
    }

    private func displayCheckoutSummaryViewController(checkoutViewModel: CheckoutViewModel) {
        let checkoutSummaryVC = CheckoutSummaryViewController(checkout: checkout, checkoutViewModel: checkoutViewModel)
        Async.main {
            self.showViewController(checkoutSummaryVC, sender: self)
        }
    }
}
