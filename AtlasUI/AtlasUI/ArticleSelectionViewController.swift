//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class ArticleSelectionViewController: UIViewController {

    var selectedArticle: SelectedArticle {
        didSet {
            rootStackView.configure(viewModel: selectedArticle)
        }
    }

    fileprivate let rootStackView: ArticleSelectionRootStackView = {
        let stackView = ArticleSelectionRootStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()

    init(article: Article) {
        self.selectedArticle = SelectedArticle(article: article, unitIndex: 0, quantity: 1)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        showCancelButton()
        buildView()
        setupActions()
        rootStackView.configure(viewModel: selectedArticle)
    }

    private func setupActions() {
        let stepper = rootStackView.mainStackView.quantityStackView.stepper
        stepper.addTarget(self, action: #selector(quantityChanged(stepper:)), for: .valueChanged)

        let sizeRecognizer = UITapGestureRecognizer(target: self, action: #selector(sizeTapped))
        rootStackView.mainStackView.sizeStackView.addGestureRecognizer(sizeRecognizer)
    }

    dynamic private func quantityChanged(stepper: UIStepper) {
        self.selectedArticle = SelectedArticle(article: selectedArticle.article,
                                               unitIndex: selectedArticle.unitIndex,
                                               quantity: Int(stepper.value))
    }

    dynamic private func sizeTapped() {
        guard !selectedArticle.article.hasSingleUnit else { return }

        let sizeSelectionViewController = SizeListSelectionViewController(article: selectedArticle.article) { [weak self] selectedArticle in
            guard let strongSelf = self else { return }
            if strongSelf.selectedArticle.quantity > selectedArticle.unit.stock {
                strongSelf.selectedArticle = SelectedArticle(article: selectedArticle.article,
                                                             unitIndex: selectedArticle.unitIndex,
                                                             quantity: selectedArticle.unit.stock)
            } else {
                strongSelf.selectedArticle = selectedArticle
            }
        }
        navigationController?.pushViewController(sizeSelectionViewController, animated: true)
    }

}

extension ArticleSelectionViewController: UIBuilder {

    func configureView() {
        view.addSubview(rootStackView)
        view.backgroundColor = .white
    }

    func configureConstraints() {
        rootStackView.fillInSuperview()
    }

}

//
//fileprivate func presentCheckoutScreen(selectedArticle: SelectedArticle) {
//    let hasSingleUnit = selectedArticle.article.hasSingleUnit
//    guard AtlasAPIClient.shared?.isAuthorized == true else {
//        let actionHandler = NotLoggedInSummaryActionHandler()
//        let dataModel = CheckoutSummaryDataModel(selectedArticle: selectedArticle,
//                                                 totalPrice: selectedArticle.price)
//        let viewModel = CheckoutSummaryViewModel(dataModel: dataModel, layout: NotLoggedInLayout())
//        return presentCheckoutSummaryViewController(viewModel: viewModel, actionHandler: actionHandler)
//    }
//
//    AtlasUIClient.customer { [weak self] customerResult in
//        guard let customer = customerResult.process(forceFullScreenError: hasSingleUnit) else { return }
//
//        LoggedInSummaryActionHandler.create(customer: customer, selectedArticle: selectedArticle) { actionHandlerResult in
//            guard let actionHandler = actionHandlerResult.process(forceFullScreenError: hasSingleUnit) else { return }
//
//            let dataModel = CheckoutSummaryDataModel(selectedArticle: selectedArticle, cartCheckout: actionHandler.cartCheckout)
//            let viewModel = CheckoutSummaryViewModel(dataModel: dataModel, layout: LoggedInLayout())
//            self?.presentCheckoutSummaryViewController(viewModel: viewModel, actionHandler: actionHandler)
//        }
//    }
//}
//
//fileprivate func presentCheckoutSummaryViewController(viewModel: CheckoutSummaryViewModel,
//                                                      actionHandler: CheckoutSummaryActionHandler) {
//    let hasSingleUnit = viewModel.dataModel.selectedArticle.article.hasSingleUnit
//    let checkoutSummaryVC = CheckoutSummaryViewController(viewModel: viewModel)
//    checkoutSummaryVC.actionHandler = actionHandler
//    navigationController?.pushViewController(checkoutSummaryVC, animated: !hasSingleUnit)
//}
