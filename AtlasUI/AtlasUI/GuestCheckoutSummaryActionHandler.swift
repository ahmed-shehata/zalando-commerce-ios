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
        let paymentSelectionRequest = GuestPaymentSelectionRequest(customer: customer,
                                                                   shippingAddress: shippingGuestAddress,
                                                                   billingAddress: billingGuestAddress,
                                                                   cart: cart)
        AtlasUIClient.guestChecoutPaymentSelectionURL(paymentSelectionRequest) { result in
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
        let creationStrategy = ShippingAddressViewModelCreationStrategy()
        let addressViewController = AddressListViewController(initialAddresses: addresses, selectedAddress: shippingAddress)
        addressViewController.addressUpdatedHandler = { self.addressUpdated($0) }
        addressViewController.addressDeletedHandler = { self.addressDeleted($0) }
        addressViewController.addressSelectedHandler = { self.selectShippingAddress($0) }
        addressViewController.actionHandler = GuestCheckoutAddressListActionHandler(addressViewModelCreationStrategy: creationStrategy)
        addressViewController.title = Localizer.string("addressListView.title.shipping")
        AtlasUIViewController.instance?.mainNavigationController.pushViewController(addressViewController, animated: true)
    }

    func showBillingAddressSelectionScreen() {
        let creationStrategy = BillingAddressViewModelCreationStrategy()
        let addressViewController = AddressListViewController(initialAddresses: addresses, selectedAddress: billingAddress)
        addressViewController.addressUpdatedHandler = { self.addressUpdated($0) }
        addressViewController.addressDeletedHandler = { self.addressDeleted($0) }
        addressViewController.addressSelectedHandler = { self.selectBillingAddress($0) }
        addressViewController.actionHandler = GuestCheckoutAddressListActionHandler(addressViewModelCreationStrategy: creationStrategy)
        addressViewController.title = Localizer.string("addressListView.title.billing")
        AtlasUIViewController.instance?.mainNavigationController.pushViewController(addressViewController, animated: true)
    }

}

extension GuestCheckoutSummaryActionHandler {

    private func getGuestCheckout(checkoutId: String, token: String) {
        AtlasUIClient.guestCheckout(checkoutId, token: token) { [weak self] result in
            guard let guestCheckout = result.process() else { return }
            self?.guestCheckout = guestCheckout
        }
    }

    private func updateDataModel(addresses: CheckoutAddresses?, guestCheckout: GuestCheckout?) {
        guard let selectedUnit = dataSource?.dataModel.selectedArticleUnit else { return }
        let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedUnit, guestCheckout: guestCheckout, addresses: addresses)
        delegate?.dataModelUpdated(dataModel)
    }

}

extension GuestCheckoutSummaryActionHandler {

    private func addressUpdated(address: EquatableAddress) {
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

    private func appendAddress(address: EquatableAddress) {
        if !addresses.contains({ $0 == address }) {
            addresses.append(address)
        }
    }

}
