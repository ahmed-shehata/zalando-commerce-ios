//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class GuestCheckoutSummaryActionHandler: CheckoutSummaryActionHandler {

    weak var dataSource: CheckoutSummaryActionHandlerDataSource?
    weak var delegate: CheckoutSummaryActionHandlerDelegate?

    fileprivate let guestAddressActionHandler = GuestAddressActionHandler()
    fileprivate var guestCheckout: GuestCheckout? {
        didSet {
            updateDataModel(addresses: addresses, guestCheckout: guestCheckout)
        }
    }

    init(email: String) {
        self.guestAddressActionHandler.emailAddress = email
    }

    func handleSubmit() {
        guard let dataSource = dataSource else { return }
        guard let email = guestAddressActionHandler.emailAddress,
            let shippingAddress = shippingAddress,
            let billingAddress = billingAddress else {
            UserMessage.displayError(error: AtlasCheckoutError.missingAddress)
            return
        }
        guard let guestCheckout = guestCheckout else {
            UserMessage.displayError(error: AtlasCheckoutError.missingAddressAndPayment)
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
        AtlasUIClient.createGuestOrder(request: request) { [weak self] result in
            guard let order = result.process() else { return }
            self?.handleOrderConfirmation(order: order)
        }
    }

    func handlePaymentSelection() {
        guard let dataSource = dataSource else { return }
        guard let email = guestAddressActionHandler.emailAddress,
            let shippingAddress = shippingAddress,
            let billingAddress = billingAddress else {
            UserMessage.displayError(error: AtlasCheckoutError.missingAddress)
            return
        }
        guard let callbackURL = AtlasAPIClient.shared?.config.checkoutGatewayURL else {
            UserMessage.displayError(error: AtlasCheckoutError.unclassified)
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
        AtlasUIClient.guestCheckoutPaymentSelectionURL(request: request) { result in
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

            AtlasUIViewController.shared?.mainNavigationController.pushViewController(paymentViewController, animated: true)
        }
    }

    func handleShippingAddressSelection() {
        guestAddressActionHandler.addressCreationStrategy = ShippingAddressViewModelCreationStrategy()
        guestAddressActionHandler.handleAddressModification(address: shippingAddress) { [weak self] address in
            let checkoutAddress = self?.guestAddressActionHandler.checkoutAddresses(shippingAddress: address, billingAddress: self?.billingAddress)
            self?.updateDataModel(addresses: checkoutAddress, guestCheckout: self?.guestCheckout)
        }
    }

    func handleBillingAddressSelection() {
        guestAddressActionHandler.addressCreationStrategy = BillingAddressViewModelCreationStrategy()
        guestAddressActionHandler.handleAddressModification(address: billingAddress) { [weak self] address in
            let checkoutAddress = self?.guestAddressActionHandler.checkoutAddresses(shippingAddress: self?.shippingAddress, billingAddress: address)
            self?.updateDataModel(addresses: checkoutAddress, guestCheckout: self?.guestCheckout)
        }
    }

}

extension GuestCheckoutSummaryActionHandler {

    fileprivate func handleOrderConfirmation(order: GuestOrder) {
        guard let paymentURL = order.externalPaymentURL else {
            showConfirmationScreen(order: order)
            return
        }

        guard let callbackURL = AtlasAPIClient.shared?.config.checkoutGatewayURL else {
            UserMessage.displayError(error: AtlasCheckoutError.unclassified)
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
        AtlasUIViewController.shared?.mainNavigationController.pushViewController(paymentViewController, animated: true)
    }

    fileprivate func showConfirmationScreen(order: GuestOrder) {
        guard let dataSource = dataSource,
            let delegate = delegate,
            let email = guestAddressActionHandler.emailAddress
            else { return }

        let selectedArticleUnit = dataSource.dataModel.selectedArticleUnit
        let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit,
                                                 guestCheckout: guestCheckout,
                                                 email: email,
                                                 guestOrder: order)
        delegate.updated(actionHandler: OrderPlacedSummaryActionHandler())
        delegate.updated(dataModel: dataModel)
        delegate.updated(layout: GuestOrderPlacedLayout())
    }

    fileprivate func getGuestCheckout(checkoutId: String, token: String) {
        AtlasUIClient.guestCheckout(checkoutId: checkoutId, token: token) { [weak self] result in
            guard let guestCheckout = result.process() else { return }
            self?.guestCheckout = guestCheckout
        }
    }

    fileprivate func updateDataModel(addresses: CheckoutAddresses?, guestCheckout: GuestCheckout?) {
        guard let selectedUnit = dataSource?.dataModel.selectedArticleUnit,
            let email = guestAddressActionHandler.emailAddress
            else { return }
        let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedUnit,
                                                 guestCheckout: guestCheckout,
                                                 email: email,
                                                 addresses: addresses)
        delegate?.updated(dataModel: dataModel)
    }

}
