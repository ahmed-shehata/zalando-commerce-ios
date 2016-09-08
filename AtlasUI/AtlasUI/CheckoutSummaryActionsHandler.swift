//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct CheckoutSummaryActionsHandler {

    internal unowned let viewController: CheckoutSummaryViewController

}

extension Checkout {

    func hasSameAddress(like checkoutViewModel: CheckoutViewModel) -> Bool {
        if let billingAddress = checkoutViewModel.selectedBillingAddress,
            shippingAddress = checkoutViewModel.selectedShippingAddress {
                return shippingAddress == self.shippingAddress &&
                billingAddress == self.billingAddress
        }
        return false
    }

}

extension CheckoutSummaryActionsHandler {

    internal func handleBuyAction() {
        guard let checkout = viewController.checkoutViewModel.checkout else { return }

        viewController.loaderView.show()
        if checkout.hasSameAddress(like: viewController.checkoutViewModel) {
            createOrder(checkout.id)
            return
        }

        let updateCheckoutRequest = UpdateCheckoutRequest(billingAddressId:
                viewController.checkoutViewModel.selectedBillingAddress?.id,
            shippingAddressId: viewController.checkoutViewModel.selectedShippingAddress?.id)

        viewController.checkout.client.updateCheckout(checkout.id, updateCheckoutRequest: updateCheckoutRequest) { result in
            switch result {
            case .failure(let error):
                self.viewController.userMessage.show(error: error)
            case .success(let checkout):
                self.createOrder(checkout.id)
            }
        }
    }

    internal func createOrder (checkoutId: String) {
        viewController.checkout.client.createOrder(checkoutId) { result in
            self.viewController.loaderView.show()
            switch result {
            case .failure(let error):
                self.viewController.userMessage.show(error: error)
            case .success (let order):
                self.handleOrderConfirmation(order)
            }
        }
    }

}

extension CheckoutSummaryActionsHandler {

    internal func loadCustomerData() {
        viewController.checkout.client.customer { result in
            Async.main {
                switch result {
                case .failure(let error):
                    self.viewController.userMessage.show(error: error)
                case .success(let customer):
                    self.generateCheckout(customer)
                }
            }
        }
    }

    private func generateCheckout(customer: Customer) {
        viewController.loaderView.show()
        viewController.checkout.createCheckoutViewModel(withArticle: viewController.checkoutViewModel.article,
            selectedUnitIndex: viewController.checkoutViewModel.selectedUnitIndex) { result in
                self.viewController.loaderView.hide()
                switch result {
                case .failure(let error):
                    self.viewController.dismissViewControllerAnimated(true) {
                        self.viewController.userMessage.show(error: error)
                    }
                case .success(var checkoutViewModel):
                    checkoutViewModel.customer = customer
                    self.viewController.checkoutViewModel = checkoutViewModel
                    self.viewController.viewState = checkoutViewModel.checkoutViewState
                }
        }
    }

}

extension CheckoutSummaryActionsHandler {

    internal func showPaymentSelectionScreen() {
        guard Atlas.isUserLoggedIn() else { return loadCustomerData() }
        guard let paymentURL = viewController.checkoutViewModel.checkout?.payment.selectionPageUrl else { return }

        let paymentSelectionViewController = PaymentSelectionViewController(paymentSelectionURL: paymentURL)
        paymentSelectionViewController.paymentCompletion = { _ in
            self.loadCustomerData()
        }
        viewController.showViewController(paymentSelectionViewController, sender: viewController)
    }

    internal func showShippingAddressSelectionScreen() {
        guard Atlas.isUserLoggedIn() else { return loadCustomerData() }
        let addressSelectionViewController = AddressPickerViewController(checkout: viewController.checkout,
            addressType: .shipping, addressSelectionCompletion: pickedAddressCompletion)
        addressSelectionViewController.selectedAddress = viewController.checkoutViewModel.selectedShippingAddress
        viewController.showViewController(addressSelectionViewController, sender: viewController)
    }

    internal func showBillingAddressSelectionScreen() {
        guard Atlas.isUserLoggedIn() else { return loadCustomerData() }
        let addressSelectionViewController = AddressPickerViewController(checkout: viewController.checkout, addressType: .billing,
            addressSelectionCompletion: pickedAddressCompletion)
        addressSelectionViewController.selectedAddress = viewController.checkoutViewModel.selectedBillingAddress
        viewController.showViewController(addressSelectionViewController, sender: viewController)
    }

    internal func handleOrderConfirmation(order: Order) {
        guard let paymentURL = order.externalPaymentUrl else {
            self.viewController.viewState = .OrderPlaced
            return
        }

        let paymentSelectionViewController = PaymentSelectionViewController(paymentSelectionURL: paymentURL)
        paymentSelectionViewController.paymentCompletion = { _ in
            self.viewController.viewState = .OrderPlaced
        }
        viewController.showViewController(paymentSelectionViewController, sender: viewController)
    }

}

extension CheckoutSummaryActionsHandler {
    func pickedAddressCompletion(pickedAddress address: Addressable,
        forAddressType addressType: AddressType) {

            switch addressType {
            case AddressType.billing:
                guard let billingAddress = BillingAddress(address: address) else { return }
                viewController.checkoutViewModel.selectedBillingAddress = billingAddress
            case AddressType.shipping:
                guard let shippingAddress = ShippingAddress(address: address) else { return }
                viewController.checkoutViewModel.selectedShippingAddress = shippingAddress
            }
            viewController.loaderView.hide()
            viewController.rootStackView.configureData(viewController)
            viewController.refreshViewData()
            guard let ready = viewController.checkoutViewModel.isReadyToCreateCheckout where ready == true
            else { return }
            viewController.loaderView.show()
            guard let cartId = viewController.checkoutViewModel.cartId else { return }

            viewController.createCheckout(cartId) { result in
                self.viewController.loaderView.hide()
                switch result {

                case .failure(let error):
                    self.viewController.dismissViewControllerAnimated(true) {
                        self.viewController.userMessage.show(error: error)
                    }
                case .success(let checkout):
                    self.viewController.checkoutViewModel.checkout = checkout
                    self.viewController.rootStackView.configureData(self.viewController)
                    self.viewController.refreshViewData()
                }
            }
    }
}
