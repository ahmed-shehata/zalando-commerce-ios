//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class CheckoutSummaryViewController: UIViewController, CheckoutSummaryActionHandlerDelegate {

    var actionHandler: CheckoutSummaryActionHandler {
        didSet {
            actionHandler.delegate = self
            viewModel.uiModel = actionHandler.uiModel
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

    init(dataModel: CheckoutSummaryDataModel, actionHandler: CheckoutSummaryActionHandler) {
        self.viewModel = CheckoutSummaryViewModel(dataModel: dataModel, uiModel: actionHandler.uiModel)
        self.actionHandler = actionHandler
        super.init(nibName: nil, bundle: nil)
        ({ [weak self] in self?.actionHandler = actionHandler }) ()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        setupActions()
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
        title = Localizer.string(viewModel.uiModel.navigationBarTitleLocalizedKey)

        let hasSingleUnit = viewModel.dataModel.selectedArticleUnit.article.hasSingleUnit
        navigationItem.setHidesBackButton(viewModel.uiModel.hideBackButton(hasSingleUnit), animated: false)

        if viewModel.uiModel.showCancelButton {
            showCancelButton()
        } else {
            hideCancelButton()
        }
    }

}

extension CheckoutSummaryViewController {

    dynamic private func submitButtonTapped() {
        actionHandler.handleSubmitButton()
    }

    dynamic private func shippingAddressTapped() {
        actionHandler.showShippingAddressSelectionScreen()
    }

    dynamic private func billingAddressTapped() {
        actionHandler.showBillingAddressSelectionScreen()
    }

    dynamic private func paymentAddressTapped() {
        actionHandler.showPaymentSelectionScreen()
    }

    func dismissView() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
