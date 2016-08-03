//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

final class CheckoutSummaryViewController: UIViewController {

    private let productImageView = UIImageView()
    private let productNameLabel = UILabel()
    private let purchasedObjectSummaryLabel = UILabel()
    private let termsAndConditionsButton = UIButton()
    private let paymentSummaryTableview = UITableView()
    private let shippingPrice: Float = 0
    private let stackView: UIStackView = UIStackView()
    private var customer: Customer? = nil
    private var checkoutViewModel: CheckoutViewModel
    private let checkoutService = CheckoutService()

    init(customer: Customer?, checkoutView: CheckoutViewModel) {
        if let customer = customer {
            self.customer = customer
        }
        self.checkoutViewModel = checkoutView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Async.main {
            self.setupViews()
        }
    }

    private func setupViews() {
        self.view.removeAllSubviews()
        self.title = "Summary".loc
        self.view.backgroundColor = UIColor.clearColor()
        self.view.opaque = false
        self.setupNavBar()
        self.setupBlurView()
        self.setupProductImageView()
        self.setupViewLabels()
        self.setupStackView()
        self.setupTermsAndConditionsButton()
        self.setupBuyButton()
    }

    @objc private func buyButtonTapped(sender: UIButton) {
        let paymentProcessingViewController = PaymentProcessingViewController(checkoutView: self.checkoutViewModel)

        self.showViewController(paymentProcessingViewController, sender: self)
    }

    @objc private func connectToZalandoButtonTapped(sender: UIButton) {
        connectToZalando()
    }

    @objc private func cancelCheckoutTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    private func showLoadingView() {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        backgroundView.backgroundColor = .grayColor()
        backgroundView.alpha = 0.2
        indicator.center = CGPoint(x: self.view.bounds.size.width / 2, y: (self.view.bounds.size.height) / 2)
        indicator.color = .blackColor()
        indicator.startAnimating()
        self.view.addSubview(backgroundView)
        self.view.addSubview(indicator)
    }

    private func setupNavBar() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        if let article = self.checkoutViewModel.article where article.hasSingleUnit {
            self.navigationItem.setHidesBackButton(true, animated: false)
        }

        let cancelButton = UIBarButtonItem(title: "Cancel".loc, style: UIBarButtonItemStyle.Plain,
            target: self, action: #selector(CheckoutSummaryViewController.cancelCheckoutTapped(_:)))
        navigationItem.rightBarButtonItem = cancelButton
    }

    private func connectToZalando() {
        AtlasSDK.fetchCustomer { result in
            switch result {
            case .failure(let error):
                let alert = UIAlertController(title: "Error".loc, message: "\(error)", preferredStyle: .Alert)
                self.presentViewController(alert, animated: true, completion: nil)

            case .success(let customer):
                self.showLoadingView()

                if let article = self.checkoutViewModel.article, articleIndex = self.checkoutViewModel.articleUnitIndex {
                    self.checkoutService.generateCheckout(withArticle: article, articleUnitIndex: articleIndex) { result in
                        switch result {
                        case .failure(let error):
                            self.dismissViewControllerAnimated(true) {
                                UserMessage.showError(title: "Fatal Error".loc, error: error)
                            }
                        case .success(let checkout):
                            self.checkoutViewModel = checkout
                            self.customer = customer
                            self.setupViews()

                        }
                    }
                }

            }
        }
    }

    private func setupProductImageView() {

        if let article = self.checkoutViewModel.article {
            productImageView.setImage(fromUrl: article.media.images.first?.catalogUrl)
        }

        productImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        productImageView.image = UIImage(named: "default-user", bundledWith: CheckoutSummaryViewController.self)

        productImageView.layer.cornerRadius = productImageView.frame.size.width / 2
        productImageView.clipsToBounds = true

        productImageView.layer.borderWidth = 0.5
        productImageView.layer.borderColor = UIColor.grayColor().CGColor
        view.addSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.widthAnchor.constraintEqualToConstant(50).active = true
        productImageView.heightAnchor.constraintEqualToAnchor(productImageView.widthAnchor).active = true
        productImageView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 50).active = true
        productImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true

    }

    private func setupViewLabels() {
        if let article = self.checkoutViewModel.article {
            productNameLabel.text = article.brand.name
            purchasedObjectSummaryLabel.text = article.name
            view.addSubview(productNameLabel)
        }

        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.textAlignment = .Center
        productNameLabel.font = productNameLabel.font.fontWithSize(12)
        productNameLabel.widthAnchor.constraintEqualToAnchor(productImageView.widthAnchor, multiplier: 2).active = true
        productNameLabel.heightAnchor.constraintEqualToConstant(20).active = true
        productNameLabel.topAnchor.constraintEqualToAnchor(productImageView.bottomAnchor).active = true
        productNameLabel.centerXAnchor.constraintEqualToAnchor(productImageView.centerXAnchor).active = true

        view.addSubview(purchasedObjectSummaryLabel)

        purchasedObjectSummaryLabel.translatesAutoresizingMaskIntoConstraints = false
        purchasedObjectSummaryLabel.textAlignment = .Center
        purchasedObjectSummaryLabel.font = purchasedObjectSummaryLabel.font.fontWithSize(10)

        purchasedObjectSummaryLabel.heightAnchor.constraintEqualToConstant(15).active = true
        purchasedObjectSummaryLabel.topAnchor.constraintEqualToAnchor(productNameLabel.bottomAnchor).active = true
        purchasedObjectSummaryLabel.centerXAnchor.constraintEqualToAnchor(productImageView.centerXAnchor).active = true
    }

    private func setupTermsAndConditionsButton() {
        self.view.addSubview(termsAndConditionsButton)
        termsAndConditionsButton.translatesAutoresizingMaskIntoConstraints = false
        let attrs = [NSFontAttributeName: UIFont.systemFontOfSize(12.0),
            NSForegroundColorAttributeName: UIColor.grayColor(),
            NSUnderlineStyleAttributeName: 1]

        termsAndConditionsButton.setAttributedTitle(NSMutableAttributedString(string:
                "Zalando terms, conditions and cancellation policy apply to all orders".loc, attributes: attrs), forState: .Normal)

        termsAndConditionsButton.heightAnchor.constraintEqualToConstant(30).active = true
        termsAndConditionsButton.titleLabel?.lineBreakMode = .ByWordWrapping
        termsAndConditionsButton.topAnchor.constraintEqualToAnchor(self.view.bottomAnchor, constant: -30).active = true
        termsAndConditionsButton.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor, constant: 10).active = true
        termsAndConditionsButton.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor, constant: -10).active = true

    }

    private func setupBuyButton() {
        let buyButton = UIButton()
        self.view.addSubview(buyButton)
        buyButton.translatesAutoresizingMaskIntoConstraints = false

        buyButton.heightAnchor.constraintEqualToConstant(50).active = true
        buyButton.topAnchor.constraintEqualToAnchor(self.termsAndConditionsButton.bottomAnchor, constant: -80).active = true
        buyButton.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor, constant: 10).active = true
        buyButton.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor, constant: -10).active = true
        if customer != nil {
            buyButton.backgroundColor = UIColor.orangeColor()
            buyButton.userInteractionEnabled = true
        } else {
            buyButton.backgroundColor = UIColor.grayColor()
            buyButton.userInteractionEnabled = false
            setupConnectToZalandoButton(buyButton)
        }

        buyButton.layer.cornerRadius = 5

        if let article = self.checkoutViewModel.articleUnit, price = article.price.amountFormatted {
            buyButton.setTitle("Pay %@".loc(price), forState: .Normal)
        }

        buyButton.addTarget(self, action: #selector(CheckoutSummaryViewController.buyButtonTapped(_:)), forControlEvents: .TouchUpInside)
    }

    private func setupConnectToZalandoButton(buyButton: UIButton) {
        let connectButton = UIButton()
        self.view.addSubview(connectButton)
        connectButton.translatesAutoresizingMaskIntoConstraints = false

        connectButton.heightAnchor.constraintEqualToConstant(50).active = true
        connectButton.bottomAnchor.constraintEqualToAnchor(buyButton.topAnchor, constant: -10).active = true
        connectButton.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor, constant: 10).active = true
        connectButton.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor, constant: -10).active = true
        connectButton.layer.cornerRadius = 5

        connectButton.backgroundColor = UIColor.orangeColor()
        connectButton.userInteractionEnabled = true

        connectButton.setTitle("Connect To Zalando".loc, forState: .Normal)

        connectButton.addTarget(self, action: #selector(CheckoutSummaryViewController.connectToZalandoButtonTapped(_:)),
            forControlEvents: .TouchUpInside)
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

}

extension CheckoutSummaryViewController {

    private func setupStackView() {
        self.stackView.removeAllSubviews()
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .Vertical
        stackView.distribution = .Fill
        stackView.alignment = .Center
        stackView.spacing = 2
        stackView.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true
        stackView.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
        stackView.bottomAnchor.constraintLessThanOrEqualToAnchor(self.view.bottomAnchor).active = true
        stackView.topAnchor.constraintEqualToAnchor(purchasedObjectSummaryLabel.bottomAnchor, constant: 10).active = true

        if let shippingViewText = checkoutViewModel.shippingAddressText, shippingView = shippingView(shippingViewText) {
            stackView.addArrangedSubviewSideFilled(shippingView)
            shippingView.heightAnchor.constraintEqualToConstant(55).active = true
        }

        if let cardText = checkoutViewModel.paymentMethodText, cardView = cardView(cardText) {
            stackView.addArrangedSubviewSideFilled(cardView)
            cardView.heightAnchor.constraintEqualToConstant(40).active = true

        }

        if let discountViewText = checkoutViewModel.discountText, discountView = discountView(discountViewText) {
            stackView.addArrangedSubviewSideFilled(discountView)
            discountView.heightAnchor.constraintEqualToConstant(40).active = true
        }

        if let paymentSummaryRow = paymentSummaryRow() {
            stackView.addArrangedSubviewSideFilled(paymentSummaryRow)
            paymentSummaryRow.heightAnchor.constraintEqualToConstant(60).active = true
        }

        if let topSeparatorView = topSeparatorView() {
            stackView.addSubview(topSeparatorView)
            topSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
            topSeparatorView.widthAnchor.constraintEqualToAnchor(stackView.widthAnchor, multiplier: 0.95).active = true
            topSeparatorView.bottomAnchor.constraintEqualToAnchor(stackView.topAnchor).active = true
            topSeparatorView.centerXAnchor.constraintEqualToAnchor(stackView.centerXAnchor).active = true
        }
    }

    private func shippingView(text: String) -> UIView? {
        let shippingView = CheckoutSummaryRow()
        shippingView.translatesAutoresizingMaskIntoConstraints = false
        shippingView.initWith("Shipping".loc, detail: text) {
            print("Shipping")
        }
        return shippingView
    }

    private func topSeparatorView() -> UIView? {
        let topSeparatorView = UIView()
        topSeparatorView.layer.borderWidth = 5
        topSeparatorView.layer.borderColor = UIColor.blackColor().CGColor
        topSeparatorView.alpha = 0.2
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        return topSeparatorView
    }

    private func discountView(text: String) -> UIView? {
        let discountView = CheckoutSummaryRow()
        discountView.translatesAutoresizingMaskIntoConstraints = false
        discountView.initWith("Discount".loc, detail: text) {
            print("Discount")
        }
        return discountView
    }

    private func paymentSummaryRow() -> UIView? {
        if let article = self.checkoutViewModel.articleUnit {
            var shippingPrice: Float? = nil
            if customer != nil {
                shippingPrice = self.shippingPrice
            }

            let paymentSummaryRow = PaymentSummaryRow.init(shippingPrice: shippingPrice,
                itemPrice: article.price)
            paymentSummaryRow.translatesAutoresizingMaskIntoConstraints = false

            return paymentSummaryRow
        }
        return nil
    }

    private func cardView(text: String) -> UIView? {
        let cardView = CheckoutSummaryRow()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.initWith("Payment".loc, detail: text) {
            print("Payment")
        }
        return cardView
    }

}

private extension UIStackView {

    private func addArrangedSubviewSideFilled(view: UIView) {
        addArrangedSubview(view: view, viewAnchor1: view.trailingAnchor, stackAnchor1: self.trailingAnchor,
            viewAnchor2: view.leadingAnchor, stackAnchor2: self.leadingAnchor)
    }

    private func addArrangedSubview(view view: UIView, viewAnchor1: NSLayoutAnchor, stackAnchor1: NSLayoutAnchor,
        viewAnchor2: NSLayoutAnchor, stackAnchor2: NSLayoutAnchor) {
            self.addArrangedSubview(view)
            viewAnchor1.constraintEqualToAnchor(stackAnchor1).active = true
            viewAnchor2.constraintEqualToAnchor(stackAnchor2).active = true
    }

}

private extension UIView {
    private func removeAllSubviews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
}
