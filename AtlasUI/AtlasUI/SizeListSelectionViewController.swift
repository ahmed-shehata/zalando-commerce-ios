//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

final class SizeListSelectionViewController: UIViewController, CheckoutProviderType {

    private let article: Article
    internal let checkout: AtlasCheckout

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.opaque = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private let loaderView: LoaderView = {
        let view = LoaderView()
        view.hidden = true
        return view
    }()

    init(checkout: AtlasCheckout, article: Article) {
        self.checkout = checkout
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

}

extension SizeListSelectionViewController: UIBuilder {

    internal func configureView() {
        view.addSubview(tableView)
        view.addSubview(loaderView)
        view.backgroundColor = .clearColor()
        view.opaque = false
        tableView.registerReusableCell(UnitSizeTableViewCell.self)
    }

    internal func configureConstraints() {
        tableView.fillInSuperView()
        loaderView.fillInSuperView()
    }

    internal func builderSubviews() -> [UIBuilder] {
        return [loaderView]
    }

}

extension SizeListSelectionViewController: UITableViewDataSource {

    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return article.availableUnits.count
    }

    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(UnitSizeTableViewCell.self, forIndexPath: indexPath) { cell in
            let unit = self.article.availableUnits[indexPath.item]
            cell.configureData(UnitSizeTableViewCellViewModel(unit: unit, localizer: self.localizer))
            cell.accessibilityIdentifier = "size-cell-\(indexPath.row)"
            return cell
        }
    }

}

extension SizeListSelectionViewController: UITableViewDelegate {

    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        guard Atlas.isUserLoggedIn() else {
            let selectedArticleUnit = SelectedArticleUnit(article: article, selectedUnitIndex: 0)
            let checkoutViewModel = CheckoutViewModel(selectedArticleUnit: selectedArticleUnit)
            return displayCheckoutSummaryViewController(checkoutViewModel)
        }

        loaderView.show()
        self.checkout.client.customer { result in
            self.loaderView.hide()

            guard let customer = result.success(errorHandlingType: .GeneralError(userMessage: self.userMessage)) else { return }
            let selectedArticleUnit = SelectedArticleUnit(article: self.article, selectedUnitIndex: indexPath.row)

            self.loaderView.show()
            self.checkout.createCheckoutViewModel(for: selectedArticleUnit) { result in
                self.loaderView.hide()

                let errorType = AtlasUIError.CancelCheckout(userMessage: self.userMessage, viewController: self)
                guard var checkoutViewModel = result.success(errorHandlingType: errorType) else { return }

                checkoutViewModel.customer = customer
                self.displayCheckoutSummaryViewController(checkoutViewModel)
            }
        }
    }

    private func displayCheckoutSummaryViewController(checkoutViewModel: CheckoutViewModel) {
        let checkoutSummaryVC = CheckoutSummaryViewController(checkout: checkout, checkoutViewModel: checkoutViewModel)
        self.showViewController(checkoutSummaryVC, sender: self)
    }

}
