//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class CheckoutSummaryViewController: UIViewController {

    var actionHandler: CheckoutSummaryActionHandler? {
        didSet {
            actionHandler?.dataSource = self
            actionHandler?.delegate = self
        }
    }

    var viewModel: CheckoutSummaryViewModel {
        didSet {
            setupNavigationBar()
            rootStackView.configureData(viewModel)
        }
    }

    private let rootStackView: CheckoutSummaryRootStackView = {
        let stackView = CheckoutSummaryRootStackView()
        stackView.axis = .Vertical
        stackView.spacing = 5
        return stackView
    }()

    init(viewModel: CheckoutSummaryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        triggerDidSet(viewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        setupActions()
    }

    private func triggerDidSet(viewModel: CheckoutSummaryViewModel) {
        self.viewModel = viewModel
    }

}

extension CheckoutSummaryViewController: UIBuilder {

    func configureView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationController?.navigationBar.accessibilityIdentifier = "checkout-summary-navigation-bar"

        view.backgroundColor = .whiteColor()
        view.addSubview(rootStackView)
    }

    func configureConstraints() {
        rootStackView.fillInSuperView()
    }

}

extension CheckoutSummaryViewController {

    private func setupActions() {
        let submitButtonRecognizer = UITapGestureRecognizer(target: self, action: #selector(submitButtonTapped))
        rootStackView.footerStackView.submitButton.addGestureRecognizer(submitButtonRecognizer)

        let shippingAddressRecognizer = UITapGestureRecognizer(target: self, action: #selector(shippingAddressTapped))
        rootStackView.mainStackView.shippingAddressStackView.addGestureRecognizer(shippingAddressRecognizer)

        let billingAddressRecognizer = UITapGestureRecognizer(target: self, action: #selector(billingAddressTapped))
        rootStackView.mainStackView.billingAddressStackView.addGestureRecognizer(billingAddressRecognizer)

        let paymentRecognizer = UITapGestureRecognizer(target: self, action: #selector(paymentAddressTapped))
        rootStackView.mainStackView.paymentStackView.addGestureRecognizer(paymentRecognizer)
    }

    private func setupNavigationBar() {
        title = Localizer.string(viewModel.layout.navigationBarTitleLocalizedKey)

        let hasSingleUnit = viewModel.dataModel.selectedArticleUnit.article.hasSingleUnit
        navigationItem.setHidesBackButton(viewModel.layout.hideBackButton(hasSingleUnit: hasSingleUnit), animated: false)

        if viewModel.layout.showCancelButton {
            showCancelButton()
        } else {
            hideCancelButton()
        }
    }

}

extension CheckoutSummaryViewController {

    dynamic private func submitButtonTapped() {
        actionHandler?.handleSubmitButton()
    }

    dynamic private func shippingAddressTapped() {
        actionHandler?.showShippingAddressSelectionScreen()
    }

    dynamic private func billingAddressTapped() {
        actionHandler?.showBillingAddressSelectionScreen()
    }

    dynamic private func paymentAddressTapped() {
        actionHandler?.showPaymentSelectionScreen()
    }

}

extension CheckoutSummaryViewController: CheckoutSummaryActionHandlerDataSource {

    var dataModel: CheckoutSummaryDataModel {
        return viewModel.dataModel
    }

}

extension CheckoutSummaryViewController: CheckoutSummaryActionHandlerDelegate {

    func dataModelUpdated(dataModel: CheckoutSummaryDataModel) {
        self.viewModel.dataModel = dataModel
    }

    func layoutUpdated(layout: CheckoutSummaryLayout) {
        self.viewModel.layout = layout
    }

    func actionHandlerUpdated(actionHandler: CheckoutSummaryActionHandler) {
        self.actionHandler = actionHandler
    }

    func dismissView() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
