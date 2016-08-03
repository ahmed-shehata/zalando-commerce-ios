//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

internal final class PaymentProcessingViewController: UIViewController {

    private let currentCheckoutViewModel: CheckoutViewModel
    private let progressIndicator = UIActivityIndicatorView()
    private let successImageView = UIImageView()
    private let checkoutService = CheckoutService()

    init(checkoutView: CheckoutViewModel) {
        self.currentCheckoutViewModel = checkoutView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal override func viewDidLoad() {
        super.viewDidLoad()
        title = "Payment".loc
        view.backgroundColor = UIColor.clearColor()
        view.opaque = false
        setupViews()
        processOrder()
    }

    private func setupViews() {
        setupBlurView()
    }

    @objc private func doneButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    private func setupLoadingIndicator() {
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        progressIndicator.startAnimating()
        progressIndicator.color = UIColor.orangeColor()
        self.view.addSubview(progressIndicator)

        progressIndicator.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        progressIndicator.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 100).active = true

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
        let doneButton = UIBarButtonItem(title: "Done".loc, style: UIBarButtonItemStyle.Plain,
            target: self, action: #selector(PaymentProcessingViewController.doneButtonTapped(_:)))

        Async.main {
            self.progressIndicator.stopAnimating()
            self.navigationItem.rightBarButtonItem = doneButton
            self.successImageView.hidden = false
        }
    }

    private func processOrder() {
        setupLoadingIndicator()
        guard let checkout = self.currentCheckoutViewModel.checkout else { return }

        checkoutService.createOrder(checkout.id) { (result) in
            switch result {
            case .failure(let error):
                AtlasLogger.logError(error)
                UserMessage.showOK(title: "Fatal Error".loc, message: String(error))
            case .success(let order):
                print(order)
                self.showSuccessImage()
            }
        }
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
