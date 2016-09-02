//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class CheckoutSummaryViewController: UIViewController, CheckoutProviderType, AddressPickerViewControllerDelegate {

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
        setupViewState()
        setupActions()
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

    private func setupView() {
        view.backgroundColor = .whiteColor()
        view.addSubview(rootStackView)
        view.addSubview(loaderView)
        rootStackView.buildView()
        loaderView.buildView()
    }

    private func setupViewState() {
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
            navigationItem.rightBarButtonItem = button
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }

}

extension CheckoutSummaryViewController {
    func addressPickerViewController(viewController: AddressPickerViewController,
                                     pickedAddress address: Address,
                                                   forAddressType addressType: AddressPickerViewController.AddressType) {

        switch addressType {
        case AddressPickerViewController.AddressType.billing:
            self.checkoutViewModel.selectedBillingAddress = BillingAddress(address: address)
            self.checkoutViewModel.selectedBillingAddressId = address.id
        case AddressPickerViewController.AddressType.shipping:
            self.checkoutViewModel.selectedShippingAddress = ShippingAddress(address: address)
            self.checkoutViewModel.selectedShippingAddressId = address.id
        }
        loaderView.hide()
        rootStackView.configureData(self)


        if checkoutViewModel.isReadyToCreateCheckout() {
            loaderView.show()
            guard let cartId = checkoutViewModel.cartId else { return }
            checkout.client.createCheckout(cartId, billingAddressId: checkoutViewModel.selectedBillingAddressId,
                                           shippingAddressId: checkoutViewModel.selectedShippingAddressId) { result in
                self.loaderView.hide()
                switch result {

                case .failure(let error):
                    self.dismissViewControllerAnimated(true) {
                        self.userMessage.show(error: error)
                    }
                case .success(let checkout):
                    self.checkoutViewModel.checkout = checkout
                    self.rootStackView.configureData(self)
                }

            }
        }
    }
}
