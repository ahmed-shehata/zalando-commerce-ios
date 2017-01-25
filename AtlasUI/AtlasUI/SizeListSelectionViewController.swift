//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

final class SizeListSelectionViewController: UIViewController {

    let sku: String
    // swiftlint:disable:next weak_delegate
    var tableViewDelegate: SizeListTableViewDelegate? {
        didSet {
            tableView.delegate = tableViewDelegate
        }
    }
    var tableViewDataSource: SizeListTableViewDataSource? {
        didSet {
            tableView.dataSource = tableViewDataSource
            tableView.isHidden = tableViewDataSource?.article.hasSingleUnit ?? true
            tableView.reloadData()
        }
    }

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.isOpaque = false
        tableView.isHidden = true
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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

}

extension SizeListSelectionViewController: UIBuilder {

    func configureView() {
        view.addSubview(tableView)
        view.backgroundColor = .clear
        view.isOpaque = false
        tableView.registerReusableCell(for: UnitSizeTableViewCell.self)
        showCancelButton()
    }

    func configureConstraints() {
        tableView.fillInSuperview()
    }

}

extension SizeListSelectionViewController {

    fileprivate func fetchSizes() {
        AtlasUIClient.article(withSKU: self.sku) { [weak self] result in
            guard let article = result.process(forceFullScreenError: true) else { return }
            self?.tableViewDelegate = SizeListTableViewDelegate(article: article, completion: self?.presentCheckoutScreen)
            self?.tableViewDataSource = SizeListTableViewDataSource(article: article)
            self?.showCancelButton()
        }
    }

    fileprivate func presentCheckoutScreen(selectedArticle: SelectedArticle) {
        let hasSingleUnit = selectedArticle.article.hasSingleUnit
        guard AtlasAPIClient.shared?.isAuthorized == true else {
            let actionHandler = NotLoggedInSummaryActionHandler()
            let dataModel = CheckoutSummaryDataModel(selectedArticle: selectedArticle,
                                                     totalPrice: selectedArticle.price)
            let viewModel = CheckoutSummaryViewModel(dataModel: dataModel, layout: NotLoggedInLayout())
            return presentCheckoutSummaryViewController(viewModel: viewModel, actionHandler: actionHandler)
        }

        AtlasUIClient.customer { [weak self] customerResult in
            guard let customer = customerResult.process(forceFullScreenError: hasSingleUnit) else { return }

            LoggedInSummaryActionHandler.create(customer: customer, selectedArticle: selectedArticle) { actionHandlerResult in
                guard let actionHandler = actionHandlerResult.process(forceFullScreenError: hasSingleUnit) else { return }

                let dataModel = CheckoutSummaryDataModel(selectedArticle: selectedArticle, cartCheckout: actionHandler.cartCheckout)
                let viewModel = CheckoutSummaryViewModel(dataModel: dataModel, layout: LoggedInLayout())
                self?.presentCheckoutSummaryViewController(viewModel: viewModel, actionHandler: actionHandler)
            }
        }
    }

    fileprivate func presentCheckoutSummaryViewController(viewModel: CheckoutSummaryViewModel,
                                                          actionHandler: CheckoutSummaryActionHandler) {
        let hasSingleUnit = viewModel.dataModel.selectedArticle.article.hasSingleUnit
        let checkoutSummaryVC = CheckoutSummaryViewController(viewModel: viewModel)
        checkoutSummaryVC.actionHandler = actionHandler
        navigationController?.pushViewController(checkoutSummaryVC, animated: !hasSingleUnit)
    }

}
