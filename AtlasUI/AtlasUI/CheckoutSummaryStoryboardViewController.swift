//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class CheckoutSummaryStoryboardViewController: UIViewController, CheckoutProviderType {

    internal var checkout: AtlasCheckout!
    internal var checkoutViewModel: CheckoutViewModel!
    internal var viewState: CheckoutViewState = .NotLoggedIn {
        didSet {
            setupSubmitButton()
            setupNavigationBar()
            refreshView()
        }
    }
    lazy private var actionsHandler: CheckoutSummaryActionsHandler = {
        CheckoutSummaryActionsHandler(viewController: self)
    }()

    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var brandNameLabel: UILabel!
    @IBOutlet private weak var articleNameLabel: UILabel!
    @IBOutlet private weak var unitSizeLabel: UILabel!
    @IBOutlet private weak var shippingAddressTitleLabel: UILabel!
    @IBOutlet private weak var shippingAddressValueLabel: UILabel!
    @IBOutlet private weak var billingAddressTitleLabel: UILabel!
    @IBOutlet private weak var billingAddressValueLabel: UILabel!
    @IBOutlet private weak var paymentTitleLabel: UILabel!
    @IBOutlet private weak var paymentValueLabel: UILabel!
    @IBOutlet private weak var shippingTitleLabel: UILabel!
    @IBOutlet private weak var shippingPriceLabel: UILabel!
    @IBOutlet private weak var totalTitleLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var footerLabel: UILabel!

    @IBOutlet private var arrowImageViews: [UIImageView] = []
    @IBOutlet private weak var priceStackView: UIStackView!
    @IBOutlet private weak var footerStackView: UIStackView!
    @IBOutlet private weak var loaderView: UIView!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var stackView: UIStackView! {
        didSet {
            stackView.subviews.flatMap{ $0 as? UIStackView }.forEach{
                $0.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                $0.layoutMarginsRelativeArrangement = true
            }
        }
    }

    internal static func instantiateFromStoryBoard(checkout: AtlasCheckout, checkoutViewModel: CheckoutViewModel) -> CheckoutSummaryStoryboardViewController? {
        let storyboard = UIStoryboard(name: "CheckoutSummaryStoryboard", bundle: NSBundle(forClass: CheckoutSummaryStoryboardViewController.self))
        guard let checkoutSummaryViewController = storyboard.instantiateInitialViewController() as? CheckoutSummaryStoryboardViewController else { return nil }

        checkoutSummaryViewController.checkout = checkout
        checkoutSummaryViewController.checkoutViewModel = checkoutViewModel
        return checkoutSummaryViewController
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        setupViewState()
    }

    internal func showLoader() {
        loaderView.hidden = false
    }

    internal func hideLoader() {
        loaderView.hidden = true
    }

    dynamic private func cancelCheckoutTapped() {
        dismissView()
    }

    private func dismissView() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction private func submitButtonTapped() {
        switch viewState {
        case .NotLoggedIn: actionsHandler.loadCustomerData()
        case .LoggedIn: actionsHandler.handleBuyAction()
        case .OrderPlaced: dismissView()
        }
    }

    @IBAction private func shippingAddressTapped() {
        // TODO when addresses are implemented
    }

    @IBAction private func billingAddressTapped() {
        // TODO when addresses are implemented
    }

    @IBAction private func paymentAddressTapped() {
        actionsHandler.showPaymentSelectionScreen()
    }

}

extension CheckoutSummaryStoryboardViewController {
    
    private func setupViewState() {
        if Atlas.isUserLoggedIn() {
            viewState = .LoggedIn
        } else {
            viewState = .NotLoggedIn
        }
    }

    private func setupSubmitButton() {
        submitButton.setTitle(loc(viewState.submitButtonTitleLocalizedKey), forState: .Normal)
        submitButton.backgroundColor = viewState.submitButtonBackgroundColor
    }

    private func setupNavigationBar() {
        title = loc(viewState.navigationBarTitleLocalizedKey)

        let hasSingleUnit = checkoutViewModel.article.hasSingleUnit
        navigationItem.setHidesBackButton(viewState.hideBackButton(hasSingleUnit), animated: false)

        if viewState.showCancelButton {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: loc("Cancel"), style: .Plain, target: self, action: #selector(CheckoutSummaryStoryboardViewController.cancelCheckoutTapped))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }

    private func refreshView() {
        hideLoader()

        articleImageView.setImage(fromUrl: checkoutViewModel.article.thumbnailUrl)
        brandNameLabel.text = checkoutViewModel.article.brand.name
        articleNameLabel.text = checkoutViewModel.article.name
        unitSizeLabel.text = loc("Size: %@", checkoutViewModel.selectedUnit.size)
        shippingAddressTitleLabel.text = loc("Address.Shipping")
        shippingAddressValueLabel.text = checkoutViewModel.shippingAddressText
        billingAddressTitleLabel.text = loc("Address.Billing")
        billingAddressValueLabel.text = checkoutViewModel.billingAddressText
        paymentTitleLabel.text = loc("Payment")
        paymentValueLabel.text = checkoutViewModel.paymentMethodText
        shippingTitleLabel.text = loc("Shipping")
        shippingPriceLabel.text = localizer.fmtPrice(checkoutViewModel.shippingPriceValue)
        totalTitleLabel.text = loc("Total")
        totalPriceLabel.text = localizer.fmtPrice(checkoutViewModel.totalPriceValue)
        footerLabel.text = loc("CheckoutSummaryViewController.terms")
        
        priceStackView.hidden = !viewState.showPrice
        footerStackView.hidden = !viewState.showFooter
        arrowImageViews.forEach{ $0.hidden = !viewState.showDetailArrow }
    }

}
