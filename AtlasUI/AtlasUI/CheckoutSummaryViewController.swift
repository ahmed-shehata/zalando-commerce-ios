//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

final class CheckoutSummaryViewController: UIViewController, CheckoutProviderType {

    internal let productImageView = UIImageView()
    internal let productNameLabel = UILabel()
    internal let purchasedObjectSummaryLabel = UILabel()
    internal let termsAndConditionsButton = UIButton()
    internal let paymentSummaryTableview = UITableView()
    internal let stackView: UIStackView = UIStackView()
    internal let buyButton = UIButton()
    internal let connectToZalandoButton = UIButton()

    internal let shippingPrice: Float = 0
    internal let shippingView = CheckoutSummaryRow()
    internal let paymentMethodView = CheckoutSummaryRow()

    internal private(set) var checkoutViewModel: CheckoutViewModel {
        didSet {
            updateData()
        }
    }

    internal var checkout: AtlasCheckout

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
        self.setupViews()
    }

    private func setupViews() {
        Async.main {
            self.view.removeAllSubviews()
            self.stackView.removeAllSubviews()
            self.title = self.loc("Summary")
            self.view.backgroundColor = UIColor.clearColor()
            self.view.opaque = false
            self.setupNavBar()
            self.setupBlurView()
            self.setupProductImageView()
            self.setupViewLabels()
            self.setupStackView()
            self.setupTermsAndConditionsButton()
            self.setupButtons()
            self.setupShippingView()
            self.setupPaymentMethodView()
            CheckoutSummaryStyler(checkoutSummaryViewController: self).stylize()
        }
    }

    @objc internal func buyButtonTapped(sender: UIButton) {
        let paymentProcessingViewController = PaymentProcessingViewController(checkout: checkout, checkoutViewModel: self.checkoutViewModel)

        self.showViewController(paymentProcessingViewController, sender: self)
    }

    @objc internal func connectToZalandoButtonTapped(sender: UIButton) {
        connectToZalando()
    }

    @objc private func cancelCheckoutTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // TODO: change to closure.
    private func showLoadingView() {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        backgroundView.backgroundColor = .grayColor()
        backgroundView.alpha = 0.2
        indicator.center = CGPoint(x: self.view.bounds.size.width / 2, y: (self.view.bounds.size.height) / 2)
        indicator.color = .blackColor()
        Async.main {
            indicator.startAnimating()
            self.view.addSubview(backgroundView)
            self.view.addSubview(indicator)
        }
    }

    private func setupNavBar() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        // TODO: Handle single unit case inside AtlasCheckout.presentCheckoutView and present either SizeSelection or CheckoutSummary
        if checkoutViewModel.article.hasSingleUnit {
            self.navigationItem.setHidesBackButton(true, animated: false)
        }

        let cancelButton = UIBarButtonItem(title: loc("Cancel"), style: UIBarButtonItemStyle.Plain,
            target: self, action: #selector(CheckoutSummaryViewController.cancelCheckoutTapped(_:)))

        navigationItem.rightBarButtonItem = cancelButton
    }

    private func connectToZalando() {
        loadCustomerData()
    }

    private func loadCustomerData() {
        checkout.client.customer { result in
            Async.main {
                switch result {
                case .failure(let error):
                    UserMessage.showError(title: self.loc("Fatal Error"), error: error)

                case .success(let customer):
                    self.showLoadingView()
                    self.generateCheckoutAndRefreshViews(customer)
                }
            }
        }
    }

    private func generateCheckoutAndRefreshViews(customer: Customer) {
        checkout.createCheckout(withArticle: checkoutViewModel.article, articleUnitIndex: checkoutViewModel.selectedUnitIndex) { result in
            switch result {
            case .failure(let error):
                self.dismissViewControllerAnimated(true) {
                    UserMessage.showError(title: self.loc("Fatal Error"), error: error)
                }
            case .success(var checkout):
                checkout.customer = customer
                self.checkoutViewModel = checkout
                self.setupViews()
            }
        }
    }

    private func setupProductImageView() {
        view.addSubview(productImageView)
    }

    private func setupViewLabels() {
        view.addSubview(productNameLabel)
        view.addSubview(purchasedObjectSummaryLabel)
    }

    private func setupTermsAndConditionsButton() {
        self.view.addSubview(termsAndConditionsButton)
    }

    private func setupButtons() {
        self.view.addSubview(buyButton)
        buyButton.hidden = true
        buyButton.setTitle(loc("Buy Now"), forState: .Normal)
        buyButton.addTarget(self, action: #selector(CheckoutSummaryViewController.buyButtonTapped(_:)),
            forControlEvents: .TouchUpInside)

        self.view.addSubview(connectToZalandoButton)
        connectToZalandoButton.hidden = true
        connectToZalandoButton.setTitle(loc("Connect To Zalando"), forState: .Normal)
        connectToZalandoButton.addTarget(self, action: #selector(CheckoutSummaryViewController.connectToZalandoButtonTapped(_:)),
            forControlEvents: .TouchUpInside)
    }

    private func setupStackView() {
        self.view.addSubview(self.stackView)
    }

    private func setupBlurView() {
        let blurEffect = UIBlurEffect(style: .ExtraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.view.addSubview(blurEffectView)

        blurEffectView.frame = self.view.bounds
        blurEffectView.frame.makeIntegralInPlace()

        let vibrancy = UIVibrancyEffect(forBlurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancy)
        vibrancyView.frame = blurEffectView.bounds
        vibrancyView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        let extraLightVibrancyView = vibrancyView
        blurEffectView.contentView.addSubview(extraLightVibrancyView)
    }

    private func setupShippingView() {
        shippingView.titleTextLabel.text = loc("Shipping")
        shippingView.detailTextLabel.text = loc("No Shipping Address")
        stackView.addArrangedSubview(shippingView)
    }

    private func setupPaymentMethodView() {
        stackView.addArrangedSubview(paymentMethodView)

        paymentMethodView.tapAction = {
            guard let paymentURL = self.checkoutViewModel.checkout?.payment.selectionPageUrl else { return }
            let paymentSelectionViewController = PaymentSelectionViewController(paymentSelectionURL: paymentURL)
            paymentSelectionViewController.paymentCompletion = { _ in
                self.loadCustomerData()
            }
            self.showViewController(paymentSelectionViewController, sender: self)
        }
    }

    private func updateData() {
        paymentMethodView.titleTextLabel.text = loc("Payment")
        paymentMethodView.detailTextLabel.text = self.checkoutViewModel.paymentMethodText ?? loc("No Payment Method")

        productNameLabel.text = checkoutViewModel.article.brand.name
        purchasedObjectSummaryLabel.text = checkoutViewModel.article.name

        productImageView.setImage(fromUrl: checkoutViewModel.article.thumbnailUrl)

        shippingView.detailTextLabel.text = self.checkoutViewModel.shippingAddressText
    }

}

