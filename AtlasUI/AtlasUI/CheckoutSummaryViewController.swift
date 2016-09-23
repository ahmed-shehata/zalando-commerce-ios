//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class CheckoutSummaryViewController: UIViewController, CheckoutProviderType {

    internal var checkout: AtlasCheckout
    internal var checkoutViewModel: CheckoutViewModel
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

    internal func showLoader() {
//        Async.main {
        self.loaderView.show()
//        }
    }

    internal func hideLoader() {
//        Async.main {
        self.loaderView.hide()
//        }
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

    dynamic private func cancelCheckoutTapped() {
        dismissView()
    }

    private func dismissView() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    dynamic private func submitButtonTapped() {
        switch viewState {
        case .NotLoggedIn: actionsHandler.loadCustomerData()
        case .LoggedIn: actionsHandler.handleBuyAction()
        case .OrderPlaced: dismissView()
        case .CheckoutIncomplete: break
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

    func refreshViewData() {
        viewState = checkoutViewModel.checkoutViewState
    }

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
        title = loc(viewState.navigationBarTitleLocalizedKey)

        let hasSingleUnit = checkoutViewModel.article.hasSingleUnit
        navigationItem.setHidesBackButton(viewState.hideBackButton(hasSingleUnit), animated: false)

        if viewState.showCancelButton {
            let button = UIBarButtonItem(title: loc("Cancel"),
                style: .Plain,
                target: self,
                action: #selector(CheckoutSummaryViewController.cancelCheckoutTapped))
            button.accessibilityIdentifier = "navigation-bar-cancel-button"
            navigationItem.rightBarButtonItem = button

            navigationController?.navigationBar.translucent = false
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }

    func createCheckout(cartId: String, completion: CheckoutCompletion) {
        checkout.client.createCheckout(cartId,
            billingAddressId: checkoutViewModel.selectedShippingAddress?.id,
            shippingAddressId: checkoutViewModel.selectedBillingAddress?.id) { checkout in
                completion(checkout)
        }
    }

}
