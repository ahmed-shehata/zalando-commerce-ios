//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class CheckoutSummaryViewController: UIViewController {

    var actionHandler: CheckoutSummaryActionHandler? {
        didSet {
            actionHandler?.dataSource = self
            actionHandler?.delegate = self
            configureEditArticleDelegate()
        }
    }

    fileprivate var viewModel: CheckoutSummaryViewModel {
        didSet {
            viewModelDidSet()
        }
    }

    fileprivate lazy var rootStackView: CheckoutSummaryRootStackView = {
        let stackView = CheckoutSummaryRootStackView()
        stackView.axis = .vertical
        stackView.productStackView.editArticleStackView.dataSource = self
        return stackView
    }()

    init(viewModel: CheckoutSummaryViewModel) {
        self.viewModel = viewModel
        defer { viewModelDidSet() }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        setupActions()
        rootStackView.productStackView.editArticleStackView.displayInitialSizes()
    }

    private func viewModelDidSet() {
        setupNavigationBar()
        rootStackView.configure(viewModel: viewModel)
        configureEditArticleDelegate()
    }

    private func configureEditArticleDelegate() {
        rootStackView.productStackView.editArticleStackView.delegate = actionHandler
    }

}

extension CheckoutSummaryViewController: UIBuilder {

    func configureView() {
        navigationController?.navigationBar.accessibilityIdentifier = "checkout-summary-navigation-bar"
        navigationController?.navigationBar.isTranslucent = false

        view.backgroundColor = .white
        view.addSubview(rootStackView)
    }

    func configureConstraints() {
        rootStackView.fillInSuperview()
    }

}

extension CheckoutSummaryViewController {

    fileprivate func setupActions() {
        let submitButtonRecognizer = UITapGestureRecognizer(target: self, action: #selector(submitButtonTapped))
        rootStackView.checkoutContainer.footerStackView.submitButton.addGestureRecognizer(submitButtonRecognizer)

        let shippingAddressRecognizer = UITapGestureRecognizer(target: self, action: #selector(shippingAddressTapped))
        rootStackView.checkoutContainer.mainStackView.shippingAddressStackView.addGestureRecognizer(shippingAddressRecognizer)

        let billingAddressRecognizer = UITapGestureRecognizer(target: self, action: #selector(billingAddressTapped))
        rootStackView.checkoutContainer.mainStackView.billingAddressStackView.addGestureRecognizer(billingAddressRecognizer)

        let paymentRecognizer = UITapGestureRecognizer(target: self, action: #selector(paymentAddressTapped))
        rootStackView.checkoutContainer.mainStackView.paymentStackView.addGestureRecognizer(paymentRecognizer)
    }

    fileprivate func setupNavigationBar() {
        title = Localizer.format(string: viewModel.layout.navigationBarTitleLocalizedKey)

        if viewModel.layout.showCancelButton {
            showCancelButton()
        } else {
            hideCancelButton()
        }
    }

}

extension CheckoutSummaryViewController {

    dynamic fileprivate func submitButtonTapped() {
        actionHandler?.handleSubmit()
    }

    dynamic fileprivate func shippingAddressTapped() {
        actionHandler?.handleShippingAddressSelection()
    }

    dynamic fileprivate func billingAddressTapped() {
        actionHandler?.handleBillingAddressSelection()
    }

    dynamic fileprivate func paymentAddressTapped() {
        actionHandler?.handlePaymentSelection()
    }

}

extension CheckoutSummaryViewController: CheckoutSummaryActionHandlerDataSource {

    var dataModel: CheckoutSummaryDataModel {
        return viewModel.dataModel
    }

}

extension CheckoutSummaryViewController: CheckoutSummaryActionHandlerDelegate {

    func updated(dataModel: CheckoutSummaryDataModel) throws {
        let oldModel = self.viewModel.dataModel
        self.viewModel.dataModel = dataModel

        do {
            try dataModel.validate(against: oldModel)
        } catch let error {
            UserMessage.displayError(error: error)
            throw error
        }
    }

    func updated(layout: CheckoutSummaryLayout) {
        self.viewModel.layout = layout
        self.rootStackView.checkoutContainer.hideOverlay(animated: true)
    }

    func updated(actionHandler: CheckoutSummaryActionHandler) {
        self.actionHandler = actionHandler
    }

    func dismissView() {
        dismiss(animated: true, completion: nil)
    }

}

extension CheckoutSummaryViewController: CheckoutSummaryEditProductDataSource {

    var checkoutContainer: CheckoutContainerView {
        return rootStackView.checkoutContainer
    }

    var selectedArticle: SelectedArticle {
        return viewModel.dataModel.selectedArticle
    }

}
