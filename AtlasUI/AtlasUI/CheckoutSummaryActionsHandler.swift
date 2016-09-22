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
            switch result {
            case .failure(let error):
                strongViewController.userMessage.show(error: error)
                strongViewController.hideLoader()
            case .success(let checkout):
                self.createOrder(checkout.id)
            }
        }
    }

    internal func createOrder(checkoutId: String) {
        guard let strongViewController = self.viewController else { return }

        strongViewController.checkout.client.createOrder(checkoutId) { result in
            switch result {
            case .failure(let error):
                strongViewController.userMessage.show(error: error)
                strongViewController.hideLoader()
            case .success (let order):
                self.handleOrderConfirmation(order)
                strongViewController.hideLoader()
            }
        }
    }

}

extension CheckoutSummaryActionsHandler {

    internal func loadCustomerData() {
        guard let strongViewController = self.viewController else { return }

        strongViewController.checkout.client.customer { result in

            switch result {
            case .failure(let error):
                Async.main {
                    strongViewController.userMessage.show(error: error)
                }
            case .success(let customer):
                self.generateCheckout(customer)
            }

        }
    }

    private func generateCheckout(customer: Customer) {
        guard let strongViewController = self.viewController else { return }

        strongViewController.showLoader()
        strongViewController.checkout.prepareCheckoutViewModel(strongViewController.checkoutViewModel.selectedArticleUnit,
            checkoutViewModel: strongViewController.checkoutViewModel) { result in
                strongViewController.hideLoader()
                switch result {
                case .failure(let error):
                    strongViewController.dismissViewControllerAnimated(true) {
                        strongViewController.userMessage.show(error: error)
                    }
                case .success(var checkoutViewModel):
                    checkoutViewModel.customer = customer
                    strongViewController.checkoutViewModel = checkoutViewModel
                    strongViewController.viewState = checkoutViewModel.checkoutViewState
                }
        }
    }

}

extension CheckoutSummaryActionsHandler {

    internal func showPaymentSelectionScreen() {
        guard let strongViewController = self.viewController else { return }
        guard Atlas.isUserLoggedIn() else { return loadCustomerData() }
        guard let paymentURL = strongViewController.checkoutViewModel.checkout?.payment.selectionPageUrl else { return }

        let paymentSelectionViewController = PaymentSelectionViewController(paymentSelectionURL: paymentURL)
        paymentSelectionViewController.paymentCompletion = { result in
            switch result {
            case .success:
                self.loadCustomerData()
            case .failure(let error):
                strongViewController.userMessage.show(error: error)
            }
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

        guard let paymentURL = order.externalPaymentUrl else {
            strongViewController.viewState = .OrderPlaced
            return
        }

        let paymentSelectionViewController = PaymentSelectionViewController(paymentSelectionURL: paymentURL)
        paymentSelectionViewController.paymentCompletion = { result in
            switch result {
            case .success:
                strongViewController.viewState = .OrderPlaced
            case .failure(let error):
                strongViewController.userMessage.show(error: error)
            }
        }
        strongViewController.showViewController(paymentSelectionViewController, sender: strongViewController)
    }

}

extension CheckoutSummaryActionsHandler {
    func pickedAddressCompletion(pickedAddress address: EquatableAddress?,

        forAddressType addressType: AddressType, popBackToSummary: Bool) {
            guard let strongViewController = self.viewController else { return }
            if popBackToSummary {
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
            strongViewController.hideLoader()
            strongViewController.rootStackView.configureData(strongViewController)
            strongViewController.refreshViewData()

            guard strongViewController.checkoutViewModel.isReadyToCreateCheckout == true else { return }

            strongViewController.showLoader()

            strongViewController.checkout.prepareCheckoutViewModel(strongViewController.checkoutViewModel.selectedArticleUnit,
                checkoutViewModel: strongViewController.checkoutViewModel) { result in
                    strongViewController.hideLoader()
                    switch result {
                    case .failure(let error):
                        strongViewController.dismissViewControllerAnimated(true) {
                            strongViewController.userMessage.show(error: error)
                        }
                    case .success(var checkoutViewModel):
                        checkoutViewModel.customer = strongViewController.checkoutViewModel.customer
                        strongViewController.checkoutViewModel = checkoutViewModel
                        strongViewController.rootStackView.configureData(strongViewController)
                        strongViewController.refreshViewData()
                    }
            }
    }
}

extension UpdateCheckoutRequest {
    init (checkoutViewModel: CheckoutViewModel) {
        self.init(billingAddressId: checkoutViewModel.selectedBillingAddress?.id,
            shippingAddressId: checkoutViewModel.selectedBillingAddress?.id)
    }
}
