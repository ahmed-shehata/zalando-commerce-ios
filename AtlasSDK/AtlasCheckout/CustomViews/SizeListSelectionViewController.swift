//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK
import AtlasCommons
import AtlasCommonsUI

final class SizeListSelectionViewController: UITableViewController {

    private let article: Article
    private let checkoutService = CheckoutService()

    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: String(UITableViewCell))
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
        let cell = tableView.dequeueReusableCellWithIdentifier(String(UITableViewCell), forIndexPath: indexPath)
        let unit = article.units[indexPath.item]
        cell.textLabel?.text = unit.size
        cell.backgroundColor = UIColor.clearColor()
        cell.opaque = false
        cell.accessoryView = nil
        return cell
    }

    internal override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) else { return }

        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        cell.accessoryView = spinner
        spinner.startAnimating()
        tableView.userInteractionEnabled = false

        if !AtlasSDK.isUserLoggedIn() {
            let checkout = CheckoutViewModel(shippingAddressText: nil, paymentMethodText: nil, discountText: nil,
                shippingPrice: nil, totalPrice: self.article.units[indexPath.row].price, articleUnitIndex: indexPath.row,
                checkout: nil, articleUnit: self.article.units[indexPath.row], article: self.article)

            let checkoutSummaryVC = CheckoutSummaryViewController(customer: nil, checkoutView: checkout)
            self.showViewController(checkoutSummaryVC, sender: self)
        } else {
            AtlasSDK.fetchCustomer { result in
                switch result {
                case .failure(let error):
                    let alert = UIAlertController(title: "Error".loc, message: "\(error)", preferredStyle: .Alert)
                    self.presentViewController(alert, animated: true, completion: nil)

                case .success(let customer):
                    self.checkoutService.generateCheckout(withArticle: self.article, articleUnitIndex: indexPath.row) { result in
                        switch result {
                        case .failure(let error):
                            logError(error)
                            self.dismissViewControllerAnimated(true) {
                                UserMessage.showError(title: "Fatal Error".loc, error: error)
                            }
                        case .success(let checkout):
                            let checkoutSummaryVC = CheckoutSummaryViewController(customer: customer, checkoutView: checkout)
                            self.showViewController(checkoutSummaryVC, sender: self)
                        }
                    }
                }
            }
        }
    }

}
