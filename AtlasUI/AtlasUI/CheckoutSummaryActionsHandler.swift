//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct CheckoutSummaryActionsHandler {

    internal unowned let viewController: CheckoutSummaryStoryboardViewController

}

extension Checkout {
    func hasSameAddressAs (checkoutViewModel: CheckoutViewModel) -> Bool {
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

        viewController.showLoader()
        if checkout.hasSameAddressAs(viewController.checkoutViewModel) {
            createOrder(checkout.id)
        } else {
            let updateCheckoutRequest = UpdateCheckoutRequest(billingAddressId: viewController.checkoutViewModel.selectedBillingAddressId,
                shippingAddressId: viewController.checkoutViewModel.selectedShippingAddressId)
            viewController.checkout.client.updateCheckout(checkout.id, updateCheckoutRequest: updateCheckoutRequest) { result in
                switch result {
                case .failure(let error):
                    self.viewController.userMessage.show(error: error)
                case .success(let checkout):
                    self.createOrder(checkout.id)
                }
            }
        }

    }

    internal func createOrder (checkoutId: String) {
        viewController.checkout.client.createOrder(checkoutId) { result in
            self.viewController.hideLoader()
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
        viewController.showLoader()
        viewController.checkout.createCheckoutViewModel(withArticle: viewController.checkoutViewModel.article,
            selectedUnitIndex: viewController.checkoutViewModel.selectedUnitIndex) { result in
                self.viewController.hideLoader()
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
        let addressSelectionViewController = AddressPickerViewController(checkout: viewController.checkout, addressType: .shipping)
        addressSelectionViewController.delegate = viewController
        viewController.showViewController(addressSelectionViewController, sender: viewController)
    }

    internal func showBillingAddressSelectionScreen() {
        let addressSelectionViewController = AddressPickerViewController(checkout: viewController.checkout, addressType: .billing)
        addressSelectionViewController.delegate = viewController
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
