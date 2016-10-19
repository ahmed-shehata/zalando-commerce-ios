//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

final class SizeListSelectionViewController: UIViewController, CheckoutProviderType {

    internal let checkout: AtlasCheckout
    internal let sku: String
    internal var tableViewDelegate: SizeListTableViewDelegate? {
        didSet {
            tableView.delegate = tableViewDelegate
        }
    }
    internal var tableViewDataSource: SizeListTableViewDataSource? {
        didSet {
            tableView.dataSource = tableViewDataSource
            tableView.hidden = tableViewDataSource?.article.hasSingleUnit ?? true
            tableView.reloadData()
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.opaque = false
        tableView.hidden = true
        return tableView
    }()

    init(checkout: AtlasCheckout, sku: String) {
        self.checkout = checkout
        self.sku = sku
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        fetchSizes()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }

}

extension SizeListSelectionViewController: UIBuilder {

    internal func configureView() {
        view.addSubview(tableView)
        view.backgroundColor = .clearColor()
        view.opaque = false
        tableView.registerReusableCell(UnitSizeTableViewCell.self)
        showCancelButton()
    }

    internal func configureConstraints() {
        tableView.fillInSuperView()
    }

}

extension SizeListSelectionViewController {

    private func fetchSizes() {
        LoaderView.displayLoader { hideLoader in
            self.checkout.client.article(forSKU: self.sku) { [weak self] result in
                hideLoader()
                guard let article = result.process(forceFullScreenError: true) else { return }
                self?.tableViewDelegate = SizeListTableViewDelegate(article: article, completion: self?.showCheckoutScreen)
                self?.tableViewDataSource = SizeListTableViewDataSource(article: article)
                self?.showCancelButton()
            }
        }
    }

    private func showCheckoutScreen(selectedArticleUnit: SelectedArticleUnit) {
        let hasSingleUnit = selectedArticleUnit.article.hasSingleUnit
        guard Atlas.isUserLoggedIn() else {
            let checkoutViewModel = CheckoutViewModel(selectedArticleUnit: selectedArticleUnit)
            return displayCheckoutSummaryViewController(checkoutViewModel, animated: !hasSingleUnit)
        }

        LoaderView.displayLoader { [weak self] hideLoader in
            self?.checkout.client.customer { [weak self] result in
                guard let customer = result.process(forceFullScreenError: hasSingleUnit) else {
                    hideLoader()
                    return
                }

                self?.checkout.createCheckoutViewModel(forArticleUnit: selectedArticleUnit) { result in
                    hideLoader()
                    guard var checkoutViewModel = result.process(forceFullScreenError: hasSingleUnit) else { return }

                    checkoutViewModel.customer = customer
                    self?.displayCheckoutSummaryViewController(checkoutViewModel, animated: !hasSingleUnit)
                }
            }
        }
    }

    private func displayCheckoutSummaryViewController(checkoutViewModel: CheckoutViewModel, animated: Bool) {
        let checkoutSummaryVC = CheckoutSummaryViewController(checkout: checkout, checkoutViewModel: checkoutViewModel)
        navigationController?.pushViewController(checkoutSummaryVC, animated: animated)
    }

}
