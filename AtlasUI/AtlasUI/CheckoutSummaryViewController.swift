//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class CheckoutSummaryViewController: UIViewController, CheckoutProviderType {

    internal var checkout: AtlasCheckout
    internal var checkoutViewModel: CheckoutViewModel {
        didSet {
            injectCustomer(from: oldValue)
            viewState = checkoutViewModel.checkoutViewState
            checkPaymentMethod(oldValue)
            checkPriceChange(oldValue)
            createCheckout()
        }
    }
    internal var viewState: CheckoutViewState = .NotLoggedIn {
        didSet {
            setupNavigationBar()
            loaderView.hide()
            rootStackView.configureData(self)
        }
    }
    lazy private var actionsHandler: CheckoutSummaryActionsHandler = {
        CheckoutSummaryActionsHandler(viewController: self)
    }()

    internal let rootStackView: CheckoutSummaryRootStackView = {
        let stackView = CheckoutSummaryRootStackView()
        stackView.axis = .Vertical
        stackView.spacing = 5
        return stackView
    }()
    internal let loaderView: LoaderView = {
        let view = LoaderView()
        view.hidden = true
        return view
    }()

    init(checkout: AtlasCheckout, checkoutViewModel: CheckoutViewModel) {
        self.checkout = checkout
        self.checkoutViewModel = checkoutViewModel

        super.init(nibName: nil, bundle: nil)
        viewState = checkoutViewModel.checkoutViewState
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupInitialViewState()
        setupActions()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationController?.navigationBar.accessibilityIdentifier = "checkout-summary-navigation-bar"
    }
}

extension CheckoutSummaryViewController {

    private func injectCustomer(from oldViewModel: CheckoutViewModel) {
        if checkoutViewModel.customer == nil && oldViewModel.customer != nil {
            checkoutViewModel.customer = oldViewModel.customer
        }
    }

    private func checkPriceChange(oldViewModel: CheckoutViewModel) {
        guard let
            oldPrice = oldViewModel.cart?.grossTotal.amount,
            newPrice = checkoutViewModel.cart?.grossTotal.amount else { return }

        if oldPrice != newPrice {
            UserMessage.displayError(AtlasCheckoutError.priceChanged(newPrice: newPrice))
        }
    }

    private func checkPaymentMethod(oldViewModel: CheckoutViewModel) {
        guard oldViewModel.checkout?.payment.selected?.method != nil
            && checkoutViewModel.checkout?.payment.selected?.method == nil else { return }

        UserMessage.displayError(AtlasCheckoutError.paymentMethodNotAvailable)
    }

    private func createCheckout() {
        guard checkoutViewModel.isReadyToCreateCheckout else { return }

        displayLoader { [weak self] done in
            guard let strongSelf = self else { return }
            strongSelf.checkout.createCheckoutViewModel(fromModel: strongSelf.checkoutViewModel) { result in
                done()
                guard let checkoutViewModel = result.process() else { return }
                strongSelf.checkoutViewModel = checkoutViewModel
            }
        }
    }

}

extension CheckoutSummaryViewController {

    private func showLoader() {
        self.loaderView.show()
    }

    private func hideLoader() {
        self.loaderView.hide()
    }

    internal func displayLoader(block: (() -> Void) -> Void) {
        showLoader()
        block(hideLoader)
    }

}

extension CheckoutSummaryViewController {

    private func setupActions() {
        rootStackView.footerStackView.submitButton.addGestureRecognizer(UITapGestureRecognizer(target: self,
            action: #selector(CheckoutSummaryViewController.submitButtonTapped)))

        rootStackView.mainStackView.shippingAddressStackView.addGestureRecognizer(UITapGestureRecognizer(target: self,
            action: #selector(CheckoutSummaryViewController.shippingAddressTapped)))

        rootStackView.mainStackView.billingAddressStackView.addGestureRecognizer(UITapGestureRecognizer(target: self,
            action: #selector(CheckoutSummaryViewController.billingAddressTapped)))

        rootStackView.mainStackView.paymentStackView.addGestureRecognizer(UITapGestureRecognizer(target: self,
            action: #selector(CheckoutSummaryViewController.paymentAddressTapped)))
    }

    private func dismissView() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    dynamic private func submitButtonTapped() {
        switch viewState {
        case .NotLoggedIn: actionsHandler.loadCustomerData()
        case .CheckoutReady: actionsHandler.handleBuyAction()
        case .OrderPlaced: dismissView()
        case .CheckoutIncomplete: UserMessage.displayError(AtlasCheckoutError.missingAddressAndPayment)
        }
    }

    dynamic private func shippingAddressTapped() {
        guard viewState.showDetailArrow else { return }

        actionsHandler.showShippingAddressSelectionScreen()
    }

    dynamic private func billingAddressTapped() {
        guard viewState.showDetailArrow else { return }

        actionsHandler.showBillingAddressSelectionScreen()
    }

    dynamic private func paymentAddressTapped() {
        guard viewState.showDetailArrow else { return }

        actionsHandler.showPaymentSelectionScreen()
    }

}

extension CheckoutSummaryViewController {

    private func setupView() {
        view.backgroundColor = .whiteColor()
        view.addSubview(rootStackView)
        view.addSubview(loaderView)
        rootStackView.buildView()
        loaderView.buildView()
    }

    private func setupInitialViewState() {
        if Atlas.isUserLoggedIn() {
            viewState = checkoutViewModel.checkoutViewState
        } else {
            viewState = .NotLoggedIn
        }
    }

    private func setupNavigationBar() {
        title = Localizer.string(viewState.navigationBarTitleLocalizedKey)

        let hasSingleUnit = checkoutViewModel.article.hasSingleUnit
        navigationItem.setHidesBackButton(viewState.hideBackButton(hasSingleUnit), animated: false)

        if viewState.showCancelButton {
            showCancelButton()
        } else {
            hideCancelButton()
        }
    }

}
