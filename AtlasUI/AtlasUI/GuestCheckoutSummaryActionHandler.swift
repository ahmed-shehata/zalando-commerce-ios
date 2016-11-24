//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class GuestCheckoutSummaryActionHandler: CheckoutSummaryActionHandler {

    weak var dataSource: CheckoutSummaryActionHandlerDataSource?
    weak var delegate: CheckoutSummaryActionHandlerDelegate?

    private var email: String
    private var addresses: [EquatableAddress]
    var guestCheckout: GuestCheckout? {
        didSet {
            updateDataModel(addresses, guestCheckout: guestCheckout)
        }
    }

    init(email: String, address: EquatableAddress) {
        self.email = email
        self.addresses = [address]
    }

    func handleSubmitButton() {
        guard let dataSource = dataSource else { return }
        guard let shippingAddress = shippingAddress, billingAddress = billingAddress else {
            UserMessage.displayError(AtlasCheckoutError.missingAddress)
            return
        }
        guard let guestCheckout = guestCheckout else {
            UserMessage.displayError(AtlasCheckoutError.missingAddressAndPayment)
            return
        }

        let shippingGuestAddress = GuestAddressRequest(address: shippingAddress)
        let billingGuestAddress = GuestAddressRequest(address: billingAddress)
        let customer = GuestCustomerRequest(guestEmail: "test@test.com", subscribeNewsletter: false)
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
        guard let shippingAddress = shippingAddress, billingAddress = billingAddress else {
            UserMessage.displayError(AtlasCheckoutError.missingAddress)
            return
        }
        guard let callbackURL = AtlasAPIClient.instance?.config.checkoutGatewayURL else {
            UserMessage.displayError(AtlasCheckoutError.unclassified)
            return
        }

        let shippingGuestAddress = GuestAddressRequest(address: shippingAddress)
        let billingGuestAddress = GuestAddressRequest(address: billingAddress)
        let customer = GuestCustomerRequest(guestEmail: "test@test.com", subscribeNewsletter: false)
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
        let addressViewController = AddressListViewController(initialAddresses: addresses, selectedAddress: shippingAddress)
        addressViewController.emailUpdatedHandler = { self.email = $0 }
        addressViewController.addressUpdatedHandler = { self.addressUpdated($0) }
        addressViewController.addressDeletedHandler = { self.addressDeleted($0) }
        addressViewController.addressSelectedHandler = { self.selectShippingAddress($0) }
        addressViewController.actionHandler = addressListActionHandler(ShippingAddressViewModelCreationStrategy())
        addressViewController.title = Localizer.string("addressListView.title.shipping")
        AtlasUIViewController.instance?.mainNavigationController.pushViewController(addressViewController, animated: true)
    }

    func showBillingAddressSelectionScreen() {
        let addressViewController = AddressListViewController(initialAddresses: addresses, selectedAddress: billingAddress)
        addressViewController.emailUpdatedHandler = { self.email = $0 }
        addressViewController.addressUpdatedHandler = { self.addressUpdated($0) }
        addressViewController.addressDeletedHandler = { self.addressDeleted($0) }
        addressViewController.addressSelectedHandler = { self.selectBillingAddress($0) }
        addressViewController.actionHandler = addressListActionHandler(BillingAddressViewModelCreationStrategy())
        addressViewController.title = Localizer.string("addressListView.title.billing")
        AtlasUIViewController.instance?.mainNavigationController.pushViewController(addressViewController, animated: true)
    }

}

extension GuestCheckoutSummaryActionHandler {

    private func handleOrderConfirmation(order: Order) {
        guard let paymentURL = order.externalPaymentURL else {
            showConfirmationScreen(order)
            return
        }

        guard let callbackURL = AtlasAPIClient.instance?.config.payment.thirdPartyCallbackURL else {
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
        guard let dataSource = dataSource, delegate = delegate else { return }
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
        guard let selectedUnit = dataSource?.dataModel.selectedArticleUnit else { return }
        let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedUnit,
                                                 guestCheckout: guestCheckout,
                                                 email: email,
                                                 addresses: addresses)
        delegate?.dataModelUpdated(dataModel)
    }

    private func addressListActionHandler(creationStrategy: AddressViewModelCreationStrategy?) -> GuestCheckoutAddressListActionHandler {
        var actionHandler = GuestCheckoutAddressListActionHandler(addressViewModelCreationStrategy: creationStrategy)
        actionHandler.emailAddress = email
        return actionHandler
    }

}

extension GuestCheckoutSummaryActionHandler {

    private func addressUpdated(address: EquatableAddress) {
        updateAddress(address)
        if let shippingAddress = shippingAddress where shippingAddress == address {
            selectShippingAddress(address)
        }
        if let billingAddress = billingAddress where billingAddress == address {
            selectBillingAddress(address)
        }
    }

    private func addressDeleted(address: EquatableAddress) {
        removeAddress(address)
        if let shippingAddress = shippingAddress where shippingAddress == address {
            updateDataModel(CheckoutAddresses(billingAddress: billingAddress, shippingAddress: nil), guestCheckout: nil)
            guestCheckout = nil
        }
        if let billingAddress = billingAddress where billingAddress == address {
            updateDataModel(CheckoutAddresses(billingAddress: nil, shippingAddress: shippingAddress), guestCheckout: nil)
            guestCheckout = nil
        }
    }

    private func selectShippingAddress(address: EquatableAddress) {
        appendAddress(address)
        updateDataModel(CheckoutAddresses(billingAddress: billingAddress, shippingAddress: address), guestCheckout: guestCheckout)
    }

    private func selectBillingAddress(address: EquatableAddress) {
        appendAddress(address)
        updateDataModel(CheckoutAddresses(billingAddress: address, shippingAddress: shippingAddress), guestCheckout: guestCheckout)
    }

    private func removeAddress(address: EquatableAddress) {
        if let idx = addresses.indexOf({ $0 == address }) {
            addresses.removeAtIndex(idx)
        }
    }

    private func updateAddress(address: EquatableAddress) {
        if let idx = addresses.indexOf({ $0 == address }) {
            addresses.removeAtIndex(idx)
        }
    }

    private func appendAddress(address: EquatableAddress) {
        if !addresses.contains({ $0 == address }) {
            addresses.append(address)
        }
    }

}
