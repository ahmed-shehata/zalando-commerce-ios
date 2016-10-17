//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

final class SizeListSelectionViewController: UIViewController, CheckoutProviderType {

    internal let checkout: AtlasCheckout
    private let sku: String
    private var tableViewDelegate: SizeListTableViewDelegate? {
        didSet {
            tableView.dataSource = tableViewDelegate
            tableView.delegate = tableViewDelegate
            tableView.hidden = tableViewDelegate?.article.hasSingleUnit ?? true
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

    private let loaderView: LoaderView = {
        let view = LoaderView()
        view.hidden = true
        return view
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
        view.addSubview(loaderView)
        view.backgroundColor = .clearColor()
        view.opaque = false
        tableView.registerReusableCell(UnitSizeTableViewCell.self)
        showCancelButton()
    }

    internal func configureConstraints() {
        tableView.fillInSuperView()
        loaderView.fillInSuperView()
    }

    internal func builderSubviews() -> [UIBuilder] {
        return [loaderView]
    }

}

extension SizeListSelectionViewController {

    private func fetchSizes() {
        loaderView.show()
        checkout.client.article(forSKU: sku) { [weak self] result in
            self?.loaderView.hide()
            guard let article = result.process(forceFullScreenError: true) else { return }
            self?.tableViewDelegate = SizeListTableViewDelegate(article: article, completion: self?.showCheckoutScreen)
            self?.showCancelButton()
        }
    }

    private func showCheckoutScreen(selectedArticleUnit: SelectedArticleUnit, userSelected: Bool) {
        guard Atlas.isUserLoggedIn() else {
            let checkoutViewModel = CheckoutViewModel(selectedArticleUnit: selectedArticleUnit)
            return displayCheckoutSummaryViewController(checkoutViewModel, userSelected: userSelected)
        }

        loaderView.show()
        checkout.client.customer { [weak self] result in
            guard let customer = result.process(forceFullScreenError: !userSelected) else {
                self?.loaderView.hide()
                return
            }

            self?.checkout.createCheckoutViewModel(forArticleUnit: selectedArticleUnit) { result in
                self?.loaderView.hide()
                guard var checkoutViewModel = result.process(forceFullScreenError: !userSelected) else { return }

                checkoutViewModel.customer = customer
                self?.displayCheckoutSummaryViewController(checkoutViewModel, userSelected: userSelected)
            }
        }
    }

    private func displayCheckoutSummaryViewController(checkoutViewModel: CheckoutViewModel, userSelected: Bool) {
        let checkoutSummaryVC = CheckoutSummaryViewController(checkout: checkout, checkoutViewModel: checkoutViewModel)
        navigationController?.pushViewController(checkoutSummaryVC, animated: userSelected)
    }

}
