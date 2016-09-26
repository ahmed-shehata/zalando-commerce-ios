//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct CheckoutSummaryActionsHandler {

    internal weak var viewController: CheckoutSummaryViewController?

}

extension Checkout {

    func hasSameAddress(like checkoutViewModel: CheckoutViewModel) -> Bool {
        guard let billingAddress = checkoutViewModel.selectedBillingAddress,
            shippingAddress = checkoutViewModel.selectedShippingAddress else {
                return false
        }
        return shippingAddress == self.shippingAddress && billingAddress == self.billingAddress
    }

}

extension CheckoutSummaryActionsHandler {

    internal func handleBuyAction() {
        guard let strongViewController = self.viewController else { return }
        guard let checkout = strongViewController.checkoutViewModel.checkout else { return }

        strongViewController.showLoader()
        if checkout.hasSameAddress(like: strongViewController.checkoutViewModel) {
            return createOrder(checkout.id)
        }

        let updateCheckoutRequest = UpdateCheckoutRequest(checkoutViewModel: strongViewController.checkoutViewModel)

        strongViewController.checkout.client.updateCheckout(checkout.id, updateCheckoutRequest: updateCheckoutRequest) { result in
            strongViewController.hideLoader()
            guard let checkout = result.handleError(checkoutProviderType: strongViewController) else { return }
            self.createOrder(checkout.id)
        }
    }

    internal func createOrder(checkoutId: String) {
        guard let strongViewController = self.viewController else { return }

        strongViewController.showLoader()
        strongViewController.checkout.client.createOrder(checkoutId) { result in
            strongViewController.hideLoader()
            guard let order = result.handleError(checkoutProviderType: strongViewController) else { return }
            self.handleOrderConfirmation(order)
        }
    }

}

extension CheckoutSummaryActionsHandler {

    internal func loadCustomerData() {
        guard let strongViewController = self.viewController else { return }

        strongViewController.checkout.client.customer { result in
            guard let customer = result.handleError(checkoutProviderType: strongViewController) else { return }
            self.generateCheckout(customer)
        }
    }

    private func generateCheckout(customer: Customer) {
        guard let strongViewController = self.viewController else { return }

        strongViewController.showLoader()
        strongViewController.checkout.prepareCheckoutViewModel(strongViewController.checkoutViewModel.selectedArticleUnit,
            checkoutViewModel: strongViewController.checkoutViewModel) { result in
                strongViewController.hideLoader()
                guard var checkoutViewModel = result.handleError(checkoutProviderType: strongViewController,
                                                                 type: .CancelCheckoutWithError) else { return }

                checkoutViewModel.customer = customer
                strongViewController.checkoutViewModel = checkoutViewModel
                strongViewController.viewState = checkoutViewModel.checkoutViewState
        }
    }

}

extension CheckoutSummaryActionsHandler {

    internal func showPaymentSelectionScreen() {
        guard let strongViewController = self.viewController else { return }
        guard Atlas.isUserLoggedIn() else { return loadCustomerData() }
        guard let paymentURL = strongViewController.checkoutViewModel.checkout?.payment.selectionPageURL else { return }

        let paymentSelectionViewController = PaymentSelectionViewController(paymentSelectionURL: paymentURL)
        paymentSelectionViewController.paymentCompletion = { result in

            guard let _ = result.handleError(checkoutProviderType: strongViewController) else { return }
            self.loadCustomerData()
        }
        strongViewController.showViewController(paymentSelectionViewController, sender: strongViewController)
    }

    internal func showShippingAddressSelectionScreen() {
        guard let strongViewController = self.viewController else { return }
        guard Atlas.isUserLoggedIn() else { return loadCustomerData() }
        let addressSelectionViewController = AddressPickerViewController(checkout: strongViewController.checkout,
            addressType: .shipping, addressSelectionCompletion: pickedAddressCompletion)
        addressSelectionViewController.selectedAddress = strongViewController.checkoutViewModel.selectedShippingAddress
        strongViewController.showViewController(addressSelectionViewController, sender: strongViewController)
    }

    internal func showBillingAddressSelectionScreen() {
        guard let strongViewController = self.viewController else { return }
        guard Atlas.isUserLoggedIn() else { return loadCustomerData() }
        let addressSelectionViewController = AddressPickerViewController(checkout: strongViewController.checkout,
            addressType: .billing,
            addressSelectionCompletion: pickedAddressCompletion)
        addressSelectionViewController.selectedAddress = strongViewController.checkoutViewModel.selectedBillingAddress
        strongViewController.showViewController(addressSelectionViewController, sender: strongViewController)
    }

    internal func handleOrderConfirmation(order: Order) {
        guard let strongViewController = self.viewController else { return }

        guard let paymentURL = order.externalPaymentURL else {
            strongViewController.viewState = .OrderPlaced
            return
        }

        let paymentSelectionViewController = PaymentSelectionViewController(paymentSelectionURL: paymentURL)
        paymentSelectionViewController.paymentCompletion = { result in

            guard let _ = result.handleError(checkoutProviderType: strongViewController) else { return }
            strongViewController.viewState = .OrderPlaced
        }
        strongViewController.showViewController(paymentSelectionViewController, sender: strongViewController)
    }

}

extension CheckoutSummaryActionsHandler {
    func pickedAddressCompletion(pickedAddress address: EquatableAddress?,
        forAddressType addressType: AddressType, popBackToSummaryOnFinish: Bool) {
            guard let strongViewController = self.viewController else { return }

            if popBackToSummaryOnFinish {
                strongViewController.navigationController?.popViewControllerAnimated(true)
            }

            switch addressType {
            case AddressType.billing:
                strongViewController.checkoutViewModel.selectedBillingAddress = address
            case AddressType.shipping:
                strongViewController.checkoutViewModel.selectedShippingAddress = address
            }
            if address == nil {
                strongViewController.checkoutViewModel.resetState()
                strongViewController.checkoutViewModel.checkout = nil
            }

            strongViewController.rootStackView.configureData(strongViewController)
            strongViewController.refreshViewData()

            guard strongViewController.checkoutViewModel.isReadyToCreateCheckout == true else { return }

            strongViewController.showLoader()

            strongViewController.checkout.prepareCheckoutViewModel(strongViewController.checkoutViewModel.selectedArticleUnit,
                checkoutViewModel: strongViewController.checkoutViewModel) { result in
                    strongViewController.hideLoader()

                    guard var checkoutViewModel = result.handleError(checkoutProviderType: strongViewController,
                                                                     type: .CancelCheckoutWithError) else { return }

                    checkoutViewModel.customer = strongViewController.checkoutViewModel.customer
                    strongViewController.checkoutViewModel = checkoutViewModel
                    strongViewController.rootStackView.configureData(strongViewController)
                    strongViewController.refreshViewData()
            }
    }
}

extension UpdateCheckoutRequest {
    init (checkoutViewModel: CheckoutViewModel) {
        self.init(billingAddressId: checkoutViewModel.selectedBillingAddress?.id,
            shippingAddressId: checkoutViewModel.selectedShippingAddress?.id)
    }
}
