//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

internal final class PaymentProcessingViewController: UIViewController, CheckoutProviderType {

    private let currentCheckoutViewModel: CheckoutViewModel
    private let progressIndicator = UIActivityIndicatorView()
    private let successImageView = UIImageView()

    internal let checkout: AtlasCheckout

    init(checkout: AtlasCheckout, checkoutViewModel: CheckoutViewModel) {
        self.checkout = checkout
        self.currentCheckoutViewModel = checkoutViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal override func viewDidLoad() {
        super.viewDidLoad()
        title = loc("Payment")
        view.backgroundColor = UIColor.clearColor()
        view.opaque = false
        setupBlur()
        setupSuccessImage()

        processOrder()
    }

    private func processOrder() {
        setupLoadingIndicator()
        guard let checkout = self.currentCheckoutViewModel.checkout else { return }

        self.checkout.client.createOrder(checkout.id) { result in
            switch result {
            case .failure(let error):
                self.userMessage.show(error: error)
            case .success(let order):
                print(order)
                guard let paymentURL = order.externalPaymentURL else {
                    return self.showSuccessImage()
                }
                let paymentSelectionViewController = PaymentSelectionViewController(paymentSelectionURL: paymentURL)
                paymentSelectionViewController.paymentCompletion = { _ in
                    self.showSuccessImage()
                }

                let navigationController = UINavigationController(rootViewController: paymentSelectionViewController)
                navigationController.modalPresentationStyle = .OverCurrentContext
                self.navigationController?.presentViewController(navigationController, animated: true, completion: nil)

            }
        }
    }

    private func setupLoadingIndicator() {
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        progressIndicator.startAnimating()
        progressIndicator.color = UIColor.orangeColor()
        self.view.addSubview(progressIndicator)

        progressIndicator.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        progressIndicator.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 100).active = true
    }

    private func setupSuccessImage() {
        successImageView.translatesAutoresizingMaskIntoConstraints = false
        successImageView.image = UIImage(named: "success", bundledWith: PaymentProcessingViewController.self)
        successImageView.hidden = true
        self.view.addSubview(successImageView)

        successImageView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        successImageView.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 100).active = true
        successImageView.widthAnchor.constraintEqualToConstant(150).active = true
        successImageView.heightAnchor.constraintEqualToConstant(150).active = true
    }

    private func showSuccessImage() {
        let doneButton = UIBarButtonItem(title: loc("Done"), style: UIBarButtonItemStyle.Plain,
            target: self, action: #selector(PaymentProcessingViewController.doneButtonTapped(_:)))

        Async.main {
            self.progressIndicator.stopAnimating()
            self.navigationItem.rightBarButtonItem = doneButton
            self.successImageView.hidden = false
        }
    }

    @objc private func doneButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    private func setupBlur() {
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
