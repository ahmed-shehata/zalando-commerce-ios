//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class GuestCheckoutSummaryActionHandler: CheckoutSummaryActionHandler {

    weak var dataSource: CheckoutSummaryActionHandlerDataSource?
    weak var delegate: CheckoutSummaryActionHandlerDelegate?

    private let guestAddressManager = GuestAddressManager()
    private var guestCheckout: GuestCheckout? {
        didSet {
            updateDataModel(addresses, guestCheckout: guestCheckout)
        }
    }

    init(email: String) {
        self.guestAddressManager.emailAddress = email
    }

    func handleSubmitButton() {
        guard let dataSource = dataSource else { return }
        guard let email = guestAddressManager.emailAddress, shippingAddress = shippingAddress, billingAddress = billingAddress else {
            UserMessage.displayError(AtlasCheckoutError.missingAddress)
            return
        }
        guard let guestCheckout = guestCheckout else {
            UserMessage.displayError(AtlasCheckoutError.missingAddressAndPayment)
            return
        }

        let shippingGuestAddress = GuestAddressRequest(address: shippingAddress)
        let billingGuestAddress = GuestAddressRequest(address: billingAddress)
        let customer = GuestCustomerRequest(guestEmail: email, subscribeNewsletter: false)
        let cartItem = CartItemRequest(sku: dataSource.dataModel.selectedArticleUnit.sku, quantity: 1)
        let cart = GuestCartRequest(items: [cartItem])
        let payment = GuestPaymentRequest(method: guestCheckout.payment.method, metadata: guestCheckout.payment.metadata)
        let request = GuestOrderRequest(customer: customer,
                                        shippingAddress: shippingGuestAddress,
                                        billingAddress: billingGuestAddress,
                                        cart: cart,
                                        payment: payment)
        AtlasUIClient.createGuestOrder(request) { [weak self] result in
            guard let order = result.process() else { return }
            self?.handleOrderConfirmation(order)
        }
    }

    func showPaymentSelectionScreen() {
        guard let dataSource = dataSource else { return }
        guard let email = guestAddressManager.emailAddress, shippingAddress = shippingAddress, billingAddress = billingAddress else {
            UserMessage.displayError(AtlasCheckoutError.missingAddress)
            return
        }
        guard let callbackURL = AtlasAPIClient.instance?.config.checkoutGatewayURL else {
            UserMessage.displayError(AtlasCheckoutError.unclassified)
            return
        }

        let shippingGuestAddress = GuestAddressRequest(address: shippingAddress)
        let billingGuestAddress = GuestAddressRequest(address: billingAddress)
        let customer = GuestCustomerRequest(guestEmail: email, subscribeNewsletter: false)
        let cartItem = CartItemRequest(sku: dataSource.dataModel.selectedArticleUnit.sku, quantity: 1)
        let cart = GuestCartRequest(items: [cartItem])
        let request = GuestPaymentSelectionRequest(customer: customer,
                                                   shippingAddress: shippingGuestAddress,
                                                   billingAddress: billingGuestAddress,
                                                   cart: cart)
        AtlasUIClient.guestChecoutPaymentSelectionURL(request) { result in
            guard let paymentURL = result.process() else { return }

            let paymentViewController = PaymentViewController(paymentURL: paymentURL, callbackURL: callbackURL)
            paymentViewController.paymentCompletion = { [weak self] paymentStatus in
                switch paymentStatus {
                case .guestRedirect(let encryptedCheckoutId, let encryptedToken):
                    self?.getGuestCheckout(encryptedCheckoutId, token: encryptedToken)
                case .cancel:
                    break
                case .error, .redirect, .success:
                    UserMessage.displayError(AtlasCheckoutError.unclassified)
                }
            }

            AtlasUIViewController.instance?.mainNavigationController.pushViewController(paymentViewController, animated: true)
        }
    }

    func showShippingAddressSelectionScreen() {
        guestAddressManager.addressCreationStrategy = ShippingAddressViewModelCreationStrategy()
        guestAddressManager.handleAddressModification(shippingAddress) { [weak self] address in
            let checkoutAddress = self?.guestAddressManager.checkoutAddresses(address, billingAddress: self?.billingAddress)
            self?.updateDataModel(checkoutAddress, guestCheckout: self?.guestCheckout)
        }
    }

    func showBillingAddressSelectionScreen() {
        guestAddressManager.addressCreationStrategy = BillingAddressViewModelCreationStrategy()
        guestAddressManager.handleAddressModification(billingAddress) { [weak self] address in
            let checkoutAddress = self?.guestAddressManager.checkoutAddresses(self?.shippingAddress, billingAddress: address)
            self?.updateDataModel(checkoutAddress, guestCheckout: self?.guestCheckout)
        }
    }

}

extension GuestCheckoutSummaryActionHandler {

    private func handleOrderConfirmation(order: Order) {
        guard let paymentURL = order.externalPaymentURL else {
            showConfirmationScreen(order)
            return
        }

        guard let callbackURL = AtlasAPIClient.instance?.config.checkoutGatewayURL else {
            UserMessage.displayError(AtlasCheckoutError.unclassified)
            return
        }

        let paymentViewController = PaymentViewController(paymentURL: paymentURL, callbackURL: callbackURL)
        paymentViewController.paymentCompletion = { [weak self] paymentStatus in
            switch paymentStatus {
            case .success: self?.showConfirmationScreen(order)
            case .redirect, .cancel: break
            case .error, .guestRedirect: UserMessage.displayError(AtlasCheckoutError.unclassified)
            }
        }
        AtlasUIViewController.instance?.mainNavigationController.pushViewController(paymentViewController, animated: true)
    }

    private func showConfirmationScreen(order: Order) {
        guard let dataSource = dataSource, delegate = delegate, email = guestAddressManager.emailAddress else { return }
        let selectedArticleUnit = dataSource.dataModel.selectedArticleUnit
        let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit,
                                                 guestCheckout: guestCheckout,
                                                 email: email,
                                                 order: order)
        delegate.actionHandlerUpdated(OrderPlacedSummaryActionHandler())
        delegate.dataModelUpdated(dataModel)
        delegate.layoutUpdated(GuestOrderPlacedLayout())
    }

    private func getGuestCheckout(checkoutId: String, token: String) {
        AtlasUIClient.guestCheckout(checkoutId, token: token) { [weak self] result in
            guard let guestCheckout = result.process() else { return }
            self?.guestCheckout = guestCheckout
        }
    }

    private func updateDataModel(addresses: CheckoutAddresses?, guestCheckout: GuestCheckout?) {
        guard let selectedUnit = dataSource?.dataModel.selectedArticleUnit, email = guestAddressManager.emailAddress else { return }
        let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedUnit,
                                                 guestCheckout: guestCheckout,
                                                 email: email,
                                                 addresses: addresses)
        delegate?.dataModelUpdated(dataModel)
    }

}
