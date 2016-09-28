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
        guard let viewController = self.viewController else { return }
        guard let checkout = viewController.checkoutViewModel.checkout else { return }

        if checkout.hasSameAddress(like: strongViewController.checkoutViewModel) {
            return createOrder(checkout.id)
        }

        let updateCheckoutRequest = UpdateCheckoutRequest(checkoutViewModel: viewController.checkoutViewModel)

        strongViewController.displayLoaderWithRequest { done in
            strongViewController.checkout.client.updateCheckout(checkout.id, updateCheckoutRequest: updateCheckoutRequest) { result in
                switch result {
                case .failure(let error):
                    strongViewController.userMessage.show(error: error)
                    done()
                case .success(let checkout):
                    self.createOrder(checkout.id)
                }
            }
        }
    }

    internal func createOrder(checkoutId: String) {
        guard let strongViewController = self.viewController else { return }
        strongViewController.displayLoaderWithRequest { done in
            strongViewController.checkout.client.createOrder(checkoutId) { result in
                switch result {
                case .failure(let error):
                    strongViewController.userMessage.show(error: error)
                    done()
                case .success (let order):
                    self.handleOrderConfirmation(order)
                    done()
                }
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
                strongViewController.userMessage.show(error: error)
            case .success(let customer):
                self.generateCheckout(customer)
            }

        viewController.checkout.client.customer { result in
            guard let customer = result.success(errorHandlingType: .GeneralError(userMessage: viewController.userMessage)) else { return }
            self.generateCheckout(customer)
        }
    }

    private func generateCheckout(customer: Customer) {
        guard let strongViewController = self.viewController else { return }

        strongViewController.displayLoaderWithRequest { done in
            strongViewController.checkout.prepareCheckoutViewModel(strongViewController.checkoutViewModel.selectedArticleUnit,
                checkoutViewModel: strongViewController.checkoutViewModel) { result in
                    done()
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

}

extension CheckoutSummaryActionsHandler {

    internal func showPaymentSelectionScreen() {
        guard let viewController = self.viewController else { return }
        guard Atlas.isUserLoggedIn() else { return loadCustomerData() }
        guard let paymentURL = viewController.checkoutViewModel.checkout?.payment.selectionPageURL else { return }

        let paymentSelectionViewController = PaymentSelectionViewController(paymentSelectionURL: paymentURL)
        paymentSelectionViewController.paymentCompletion = { result in

            guard let _ = result.success(errorHandlingType: .GeneralError(userMessage: viewController.userMessage)) else { return }
            self.loadCustomerData()
        }
        viewController.showViewController(paymentSelectionViewController, sender: viewController)
    }

    internal func showShippingAddressSelectionScreen() {
        guard let viewController = self.viewController else { return }
        guard Atlas.isUserLoggedIn() else { return loadCustomerData() }
        let addressSelectionViewController = AddressPickerViewController(checkout: viewController.checkout,
            addressType: .shipping, addressSelectionCompletion: pickedAddressCompletion)
        addressSelectionViewController.selectedAddress = viewController.checkoutViewModel.selectedShippingAddress
        viewController.showViewController(addressSelectionViewController, sender: viewController)
    }

    internal func showBillingAddressSelectionScreen() {
        guard let viewController = self.viewController else { return }
        guard Atlas.isUserLoggedIn() else { return loadCustomerData() }
        let addressSelectionViewController = AddressPickerViewController(checkout: viewController.checkout,
            addressType: .billing,
            addressSelectionCompletion: pickedAddressCompletion)
        addressSelectionViewController.selectedAddress = viewController.checkoutViewModel.selectedBillingAddress
        viewController.showViewController(addressSelectionViewController, sender: viewController)
    }

    internal func handleOrderConfirmation(order: Order) {
        guard let viewController = self.viewController else { return }

        guard let paymentURL = order.externalPaymentURL else {
            viewController.viewState = .OrderPlaced
            return
        }

        let paymentSelectionViewController = PaymentSelectionViewController(paymentSelectionURL: paymentURL)
        paymentSelectionViewController.paymentCompletion = { result in

            guard let _ = result.success(errorHandlingType: .GeneralError(userMessage: viewController.userMessage)) else { return }
            viewController.viewState = .OrderPlaced
        }
        viewController.showViewController(paymentSelectionViewController, sender: viewController)
    }

}

extension CheckoutSummaryActionsHandler {
    func pickedAddressCompletion(pickedAddress address: EquatableAddress?,
        forAddressType addressType: AddressType, popBackToSummaryOnFinish: Bool) {
            guard let viewController = self.viewController else { return }

            if popBackToSummaryOnFinish {
                viewController.navigationController?.popViewControllerAnimated(true)
            }

            switch addressType {
            case AddressType.billing:
                viewController.checkoutViewModel.selectedBillingAddress = address
            case AddressType.shipping:
                viewController.checkoutViewModel.selectedShippingAddress = address
            }
            if address == nil {
                viewController.checkoutViewModel.resetState()
                viewController.checkoutViewModel.checkout = nil
            }

            strongViewController.rootStackView.configureData(strongViewController)
            strongViewController.refreshViewData()

            guard strongViewController.checkoutViewModel.isReadyToCreateCheckout == true else { return }

            strongViewController.displayLoaderWithRequest { done in
                strongViewController.checkout.prepareCheckoutViewModel(strongViewController.checkoutViewModel.selectedArticleUnit,
                    checkoutViewModel: strongViewController.checkoutViewModel) { result in
                        done()
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
}

extension UpdateCheckoutRequest {
    init (checkoutViewModel: CheckoutViewModel) {
        self.init(billingAddressId: checkoutViewModel.selectedBillingAddress?.id,
            shippingAddressId: checkoutViewModel.selectedShippingAddress?.id)
    }
}
