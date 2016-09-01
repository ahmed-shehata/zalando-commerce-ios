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
            refreshView()
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
    }

//    internal func showLoader() {
//        loaderView.hidden = false
//    }
//
//    internal func hideLoader() {
//        loaderView.hidden = true
//    }
}

extension CheckoutSummaryViewController {

    dynamic private func cancelCheckoutTapped() {
        dismissView()
    }

    private func dismissView() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    private func submitButtonTapped() {
        switch viewState {
        case .NotLoggedIn: actionsHandler.loadCustomerData()
        case .LoggedIn: actionsHandler.handleBuyAction()
        case .OrderPlaced: dismissView()
        }
    }

    private func shippingAddressTapped() {
        guard viewState.showDetailArrow else { return }

        userMessage.notImplemented()
    }

    private func billingAddressTapped() {
        guard viewState.showDetailArrow else { return }

        userMessage.notImplemented()
    }

    private func paymentAddressTapped() {
        guard viewState.showDetailArrow else { return }

        actionsHandler.showPaymentSelectionScreen()
    }

}

extension CheckoutSummaryViewController {

    private func setupView() {
        view.backgroundColor = .whiteColor()
        view.addSubview(rootStackView)
        rootStackView.buildView()
    }

    private func setupViewState() {
        if Atlas.isUserLoggedIn() {
            viewState = .LoggedIn
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

    private func refreshView() {
//        hideLoader()

        rootStackView.mainStackView.productStackView.articleImageView.setImage(fromUrl: checkoutViewModel.article.thumbnailUrl)
        rootStackView.mainStackView.productStackView.brandNameLabel.text = checkoutViewModel.article.brand.name
        rootStackView.mainStackView.productStackView.articleNameLabel.text = checkoutViewModel.article.name
        rootStackView.mainStackView.productStackView.unitSizeLabel.text = loc("Size: %@", checkoutViewModel.selectedUnit.size)

        rootStackView.mainStackView.shippingStackView.titleLabel.text = loc("Address.Shipping")
        rootStackView.mainStackView.shippingStackView.valueLabel.text = checkoutViewModel.shippingAddress(localizedWith: self).trimmed

        rootStackView.mainStackView.billingStackView.titleLabel.text = loc("Address.Billing")
        rootStackView.mainStackView.billingStackView.valueLabel.text = checkoutViewModel.billingAddress(localizedWith: self).trimmed

        rootStackView.mainStackView.paymentStackView.titleLabel.text = loc("Payment")
        rootStackView.mainStackView.paymentStackView.valueLabel.text = checkoutViewModel.paymentMethodText

        rootStackView.mainStackView.priceStackView.shippingTitleLabel.text = loc("Shipping")
        rootStackView.mainStackView.priceStackView.shippingValueLabel.text = localizer.fmtPrice(checkoutViewModel.shippingPriceValue)
        rootStackView.mainStackView.priceStackView.totalTitleLabel.text = loc("Total")
        rootStackView.mainStackView.priceStackView.totalValueLabel.text = localizer.fmtPrice(checkoutViewModel.totalPriceValue)

        rootStackView.footerStackView.footerLabel.text = loc("CheckoutSummaryViewController.terms")
        rootStackView.footerStackView.submitButton.setTitle(loc(viewState.submitButtonTitleLocalizedKey), forState: .Normal)
        rootStackView.footerStackView.submitButton.backgroundColor = viewState.submitButtonBackgroundColor

        rootStackView.mainStackView.priceStackView.hidden = !viewState.showPrice
        rootStackView.footerStackView.footerLabel.hidden = !viewState.showFooterLabel
        rootStackView.mainStackView.shippingStackView.arrowImageView.hidden = !viewState.showDetailArrow
        rootStackView.mainStackView.billingStackView.arrowImageView.hidden = !viewState.showDetailArrow
        rootStackView.mainStackView.paymentStackView.arrowImageView.hidden = !viewState.showDetailArrow
    }

}
