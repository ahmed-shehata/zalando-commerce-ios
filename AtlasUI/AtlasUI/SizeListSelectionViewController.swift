//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

final class SizeListSelectionViewController: UIViewController {

    let sku: String
    var tableViewDelegate: SizeListTableViewDelegate? {
        didSet {
            tableView.delegate = tableViewDelegate
        }
    }
    var tableViewDataSource: SizeListTableViewDataSource? {
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

    init(sku: String) {
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

    func configureView() {
        view.addSubview(tableView)
        view.backgroundColor = .clearColor()
        view.opaque = false
        tableView.registerReusableCell(UnitSizeTableViewCell.self)
        showCancelButton()
    }

    func configureConstraints() {
        tableView.fillInSuperView()
    }

}

extension SizeListSelectionViewController {

    private func fetchSizes() {
        AtlasAPIClient.article(self.sku) { [weak self] result in
            guard let article = result.process(forceFullScreenError: true) else { return }
            self?.tableViewDelegate = SizeListTableViewDelegate(article: article, completion: self?.showCheckoutScreen)
            self?.tableViewDataSource = SizeListTableViewDataSource(article: article)
            self?.showCancelButton()
        }
    }

    private func showCheckoutScreen(selectedArticleUnit: SelectedArticleUnit) {
        guard Atlas.isUserLoggedIn() else {
            let actionHandler = NotLoggedInActionHandler()
            return displayCheckoutSummaryViewController(selectedArticleUnit, actionHandler: actionHandler)
        }

        AtlasAPIClient.customer { [weak self] customerResult in
            guard let customer = customerResult.process(forceFullScreenError: selectedArticleUnit.article.hasSingleUnit) else { return }
            let actionHandler = LoggedInActionHandler(customer: customer)
            self?.displayCheckoutSummaryViewController(selectedArticleUnit, actionHandler: actionHandler)
        }
    }

    private func displayCheckoutSummaryViewController(selectedUnit: SelectedArticleUnit, actionHandler: CheckoutSummaryActionHandler) {
        let hasSingleUnit = selectedUnit.article.hasSingleUnit
        actionHandler.createCheckoutSummaryDataModel(selectedUnit) { [weak self] result in
            guard let dataModel = result.process(forceFullScreenError: hasSingleUnit) else { return }
            let checkoutSummaryVC = CheckoutSummaryViewController(dataModel: dataModel, actionHandler: actionHandler)
            self?.navigationController?.pushViewController(checkoutSummaryVC, animated: !hasSingleUnit)
        }
    }

}
