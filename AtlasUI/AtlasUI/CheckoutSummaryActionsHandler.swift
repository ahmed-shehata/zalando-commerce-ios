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

        if checkout.hasSameAddress(like: viewController.checkoutViewModel) {
            return createOrder(checkout.id)
        }

        let updateCheckoutRequest = UpdateCheckoutRequest(checkoutViewModel: viewController.checkoutViewModel)

        viewController.displayLoader { done in
            viewController.checkout.client.updateCheckout(checkout.id, updateCheckoutRequest: updateCheckoutRequest) { result in
                done()
                guard let checkout = result.success(errorHandlingType: .GeneralError(userMessage: viewController.userMessage)) else { return }
                self.createOrder(checkout.id)
            }
        }
    }
    internal func createOrder(checkoutId: String) {
        guard let viewController = self.viewController else { return }
        viewController.displayLoader { done in
            viewController.checkout.client.createOrder(checkoutId) { result in

                done()
                guard let order = result.success(errorHandlingType: .GeneralError(userMessage: viewController.userMessage)) else { return }
                self.handleOrderConfirmation(order)
            }
        }

    }
}

extension CheckoutSummaryActionsHandler {

    internal func loadCustomerData() {
        guard let viewController = self.viewController else { return }

        viewController.checkout.client.customer { result in

            guard let customer = result.success(errorHandlingType: .GeneralError(userMessage: viewController.userMessage)) else { return }
            self.generateCheckout(customer)
        }
    }

    private func generateCheckout(customer: Customer) {
        guard let viewController = self.viewController else { return }

        viewController.displayLoader { done in
            viewController.checkout.createCheckoutViewModel(from: viewController.checkoutViewModel) { result in
                done()
                let errorType = AtlasUIError.CancelCheckout(userMessage: viewController.userMessage, viewController: viewController)
                guard var checkoutViewModel = result.success(errorHandlingType: errorType) else { return }

                checkoutViewModel.customer = customer
                viewController.checkoutViewModel = checkoutViewModel
                viewController.viewState = checkoutViewModel.checkoutViewState
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

            if address == nil {
                if let billingAddress = viewController.checkoutViewModel.selectedBillingAddress,
                    shippingAddress = viewController.checkoutViewModel.selectedShippingAddress
                where shippingAddress == billingAddress {
                    viewController.checkoutViewModel.resetState()
                }
                viewController.checkoutViewModel.checkout = nil
            }

            switch addressType {
            case AddressType.billing:
                viewController.checkoutViewModel.selectedBillingAddress = address
            case AddressType.shipping:
                viewController.checkoutViewModel.selectedShippingAddress = address
            }

            viewController.rootStackView.configureData(viewController)
            viewController.refreshViewData()

            guard viewController.checkoutViewModel.isReadyToCreateCheckout == true else { return }

            viewController.displayLoader { done in

                viewController.checkout.createCheckoutViewModel(from: viewController.checkoutViewModel) { result in
                    done()
                    let errorType = AtlasUIError.CancelCheckout(userMessage: viewController.userMessage, viewController: viewController)
                    guard var checkoutViewModel = result.success(errorHandlingType: errorType) else { return }

                    checkoutViewModel.customer = viewController.checkoutViewModel.customer
                    viewController.checkoutViewModel = checkoutViewModel
                    viewController.rootStackView.configureData(viewController)
                    viewController.refreshViewData()
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
