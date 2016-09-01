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
            refreshView()
        }
    }
    internal let rootStackView: CheckoutSummaryRootStackView = {
        let stackView = CheckoutSummaryRootStackView()
        stackView.axis = .Vertical
        stackView.spacing = 5
        return stackView
    }()
    lazy private var actionsHandler: CheckoutSummaryActionsHandler = {
        CheckoutSummaryActionsHandler(viewController: self)
    }()

    init(checkout: AtlasCheckout, checkoutViewModel: CheckoutViewModel) {
        self.checkout = checkout
        self.checkoutViewModel = checkoutViewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    @IBOutlet private weak var articleImageView: UIImageView!
//    @IBOutlet private weak var brandNameLabel: UILabel!
//    @IBOutlet private weak var articleNameLabel: UILabel!
//    @IBOutlet private weak var unitSizeLabel: UILabel!
//    @IBOutlet private weak var shippingAddressTitleLabel: UILabel!
//    @IBOutlet private weak var shippingAddressValueLabel: UILabel!
//    @IBOutlet private weak var billingAddressTitleLabel: UILabel!
//    @IBOutlet private weak var billingAddressValueLabel: UILabel!
//    @IBOutlet private weak var paymentTitleLabel: UILabel!
//    @IBOutlet private weak var paymentValueLabel: UILabel!
//    @IBOutlet private weak var shippingTitleLabel: UILabel!
//    @IBOutlet private weak var shippingPriceLabel: UILabel!
//    @IBOutlet private weak var totalTitleLabel: UILabel!
//    @IBOutlet private weak var totalPriceLabel: UILabel!
//
//    @IBOutlet private weak var footerLabel: UILabel!
//    @IBOutlet private weak var submitButton: UIButton!
//    @IBOutlet private weak var loaderView: UIView!
//
//    @IBOutlet private var arrowImageViews: [UIImageView] = []
//    @IBOutlet private weak var priceStackView: UIStackView!
//    @IBOutlet private weak var stackView: UIStackView! {
//        didSet {
//            stackView.subviews.flatMap { $0 as? UIStackView }.forEach {
//                $0.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
//                $0.layoutMarginsRelativeArrangement = true
//            }
//        }
//    }

//    internal static func instantiateFromStoryBoard(checkout: AtlasCheckout,
//                                                   checkoutViewModel: CheckoutViewModel) -> CheckoutSummaryStoryboardViewController? {
//        let storyboard = UIStoryboard(name: "CheckoutSummaryStoryboard",
//                                      bundle: NSBundle(forClass: CheckoutSummaryStoryboardViewController.self))
//        guard let checkoutSummaryViewController = storyboard.instantiateInitialViewController()
//            as? CheckoutSummaryStoryboardViewController else { return nil }
//
//        checkoutSummaryViewController.checkout = checkout
//        checkoutSummaryViewController.checkoutViewModel = checkoutViewModel
//        return checkoutSummaryViewController
//    }

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

//    dynamic private func cancelCheckoutTapped() {
//        dismissView()
//    }
//
//    private func dismissView() {
//        dismissViewControllerAnimated(true, completion: nil)
//    }
//
//    @IBAction private func submitButtonTapped() {
//        switch viewState {
//        case .NotLoggedIn: actionsHandler.loadCustomerData()
//        case .LoggedIn: actionsHandler.handleBuyAction()
//        case .OrderPlaced: dismissView()
//        }
//    }
//
//    @IBAction private func shippingAddressTapped() {
//        guard viewState.showDetailArrow else { return }
//
//        userMessage.notImplemented()
//    }
//
//    @IBAction private func billingAddressTapped() {
//        guard viewState.showDetailArrow else { return }
//
//        userMessage.notImplemented()
//    }
//
//    @IBAction private func paymentAddressTapped() {
//        guard viewState.showDetailArrow else { return }
//
//        actionsHandler.showPaymentSelectionScreen()
//    }

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
//
//    private func setupSubmitButton() {
//        submitButton.setTitle(loc(viewState.submitButtonTitleLocalizedKey), forState: .Normal)
//        submitButton.backgroundColor = viewState.submitButtonBackgroundColor
//    }
//
//    private func setupNavigationBar() {
//        title = loc(viewState.navigationBarTitleLocalizedKey)
//
//        let hasSingleUnit = checkoutViewModel.article.hasSingleUnit
//        navigationItem.setHidesBackButton(viewState.hideBackButton(hasSingleUnit), animated: false)
//
//        if viewState.showCancelButton {
//            let button = UIBarButtonItem(title: loc("Cancel"),
//                                         style: .Plain,
//                                         target: self,
//                                         action: #selector(CheckoutSummaryStoryboardViewController.cancelCheckoutTapped))
//            navigationItem.rightBarButtonItem = button
//        } else {
//            navigationItem.rightBarButtonItem = nil
//        }
//    }
//
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



        rootStackView.footerStackView.footerLabel.text = loc("CheckoutSummaryViewController.terms")
        rootStackView.footerStackView.submitButton.setTitle(loc(viewState.submitButtonTitleLocalizedKey), forState: .Normal)
        rootStackView.footerStackView.backgroundColor = viewState.submitButtonBackgroundColor


//        shippingTitleLabel.text = loc("Shipping")
//        shippingPriceLabel.text = localizer.fmtPrice(checkoutViewModel.shippingPriceValue)
//        totalTitleLabel.text = loc("Total")
//        totalPriceLabel.text = localizer.fmtPrice(checkoutViewModel.totalPriceValue)
//
//
//        priceStackView.hidden = !viewState.showPrice
//        footerLabel.hidden = !viewState.showFooterLabel
//        arrowImageViews.forEach { $0.hidden = !viewState.showDetailArrow }
    }

}
