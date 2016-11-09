////
////  Copyright © 2016 Zalando SE. All rights reserved.
////
//
//import Foundation
//import AtlasSDK
//
//struct CheckoutSummaryActionsHandler {
//
//    weak var viewController: CheckoutSummaryViewController?
//
//}
//
//extension Checkout {
//
//    func hasSameAddress(like checkoutViewModel: CheckoutViewModel) -> Bool {
//        guard let billingAddress = checkoutViewModel.selectedBillingAddress,
//            shippingAddress = checkoutViewModel.selectedShippingAddress else {
//                return false
//        }
//        return shippingAddress == self.shippingAddress && billingAddress == self.billingAddress
//    }
//
//}
//
//extension CheckoutSummaryActionsHandler {
//
//    func handleBuyAction() {
//        guard let
//            viewController = self.viewController,
//            checkoutId = viewController.checkoutViewModel.checkout?.id
//            else { return }
//
//        UserMessage.displayLoader { hideLoader in
//            let selectedArticleUnit = viewController.checkoutViewModel.selectedArticleUnit
//            let addresses = viewController.checkoutViewModel.selectedAddresses
//            viewController.checkout.createCheckoutViewModel(selectedArticleUnit, addresses: addresses) { result in
//                hideLoader()
//                guard let checkoutViewModel = result.process() else { return }
//                viewController.checkoutViewModel = checkoutViewModel
//
//                if viewController.viewState == .CheckoutReady && !UserMessage.errorDisplayed {
//                    self.createOrder(forCheckoutId: checkoutId)
//                }
//            }
//        }
//    }
//
//    private func createOrder(forCheckoutId checkoutId: String) {
//        guard let viewController = self.viewController else { return }
//        UserMessage.displayLoader { hideLoader in
//            viewController.checkout.client.createOrder(checkoutId) { result in
//                hideLoader()
//                guard let order = result.process() else { return }
//                self.handleOrderConfirmation(order)
//            }
//        }
//    }
//
//}
//
//extension CheckoutSummaryActionsHandler {
//
//    func loadCustomerData() {
//        guard let viewController = self.viewController else { return }
//
//        UserMessage.displayLoader { hideLoader in
//            viewController.checkout.client.customer { result in
//                hideLoader()
//
//                guard let customer = result.process() else { return }
//                self.generateCheckout(customer)
//            }
//        }
//    }
//
//    func generateCheckout(customer: Customer) {
//        guard let viewController = self.viewController else { return }
//
//        UserMessage.displayLoader { hideLoader in
//            let selectedArticleUnit = viewController.checkoutViewModel.selectedArticleUnit
//            let addresses = viewController.checkoutViewModel.selectedAddresses
//            viewController.checkout.createCheckoutViewModel(selectedArticleUnit, addresses: addresses) { result in
//                hideLoader()
//                guard var checkoutViewModel = result.process() else { return }
//
//                checkoutViewModel.customer = customer
//                viewController.checkoutViewModel = checkoutViewModel
//            }
//        }
//    }
//
//}
//
//extension CheckoutSummaryActionsHandler {
//
//    func showPaymentSelectionScreen() {
//        guard let viewController = self.viewController else { return }
//        guard Atlas.isUserLoggedIn() else { return loadCustomerData() }
//        guard let paymentURL = viewController.checkoutViewModel.checkout?.payment.selectionPageURL else {
//            if viewController.checkoutViewModel.selectedShippingAddress == nil ||
//                viewController.checkoutViewModel.selectedBillingAddress == nil {
//                UserMessage.displayError(AtlasCheckoutError.missingAddress)
//            }
//            return
//        }
//
//        let callbackURL = viewController.checkout.client.config.payment.selectionCallbackURL
//        let paymentViewController = PaymentViewController(paymentURL: paymentURL, callbackURL: callbackURL)
//        paymentViewController.paymentCompletion = { result in
//            guard let paymentStatus = result.process() else { return }
//            switch paymentStatus {
//            case .redirect, .success: self.loadCustomerData()
//            case .cancel: break
//            case .error: UserMessage.displayError(AtlasCheckoutError.unclassified)
//            }
//        }
//        viewController.showViewController(paymentViewController, sender: viewController)
//    }
//
//    private func handleOrderConfirmation(order: Order) {
//        guard let viewController = self.viewController else { return }
//
//        guard let paymentURL = order.externalPaymentURL else {
//            viewController.viewState = .OrderPlaced
//            return
//        }
//
//        let callbackURL = viewController.checkout.client.config.payment.thirdPartyCallbackURL
//        let paymentViewController = PaymentViewController(paymentURL: paymentURL, callbackURL: callbackURL)
//        paymentViewController.paymentCompletion = { result in
//            guard let paymentStatus = result.process() else { return }
//            switch paymentStatus {
//            case .success: viewController.viewState = .OrderPlaced
//            case .redirect, .cancel: break
//            case .error: UserMessage.displayError(AtlasCheckoutError.unclassified)
//            }
//        }
//        viewController.showViewController(paymentViewController, sender: viewController)
//    }
//
//}
//
//extension CheckoutSummaryActionsHandler {
//
//    func showShippingAddressSelectionScreen() {
//        guard let viewController = self.viewController else { return }
//        guard Atlas.isUserLoggedIn() else { return loadCustomerData() }
//
//        UserMessage.displayLoader { hideLoader in
//            viewController.checkout.client.addresses { result in
//                hideLoader()
//                guard let addresses = result.process() else { return }
//                let addressSelectionViewController = AddressPickerViewController(checkout: viewController.checkout,
//                    initialAddresses: addresses.map { $0 },
//                    initialSelectedAddress: viewController.checkoutViewModel.selectedShippingAddress)
//                addressSelectionViewController.addressUpdatedHandler = { viewController.checkoutViewModel.addressUpdated($0) }
//                addressSelectionViewController.addressDeletedHandler = { viewController.checkoutViewModel.addressDeleted($0) }
//                addressSelectionViewController.addressSelectedHandler = { viewController.checkoutViewModel.selectedShippingAddress = $0 }
//                addressSelectionViewController.addressCreationStrategy = ShippingAddressCreationStrategy()
//                addressSelectionViewController.title = Localizer.string("addressListView.title.shipping")
//                viewController.showViewController(addressSelectionViewController, sender: nil)
//            }
//        }
//    }
//
//    func showBillingAddressSelectionScreen() {
//        guard let viewController = self.viewController else { return }
//        guard Atlas.isUserLoggedIn() else { return loadCustomerData() }
//
//        UserMessage.displayLoader { hideLoader in
//            viewController.checkout.client.addresses { result in
//                hideLoader()
//                guard let addresses = result.process() else { return }
//                let addressSelectionViewController = AddressPickerViewController(checkout: viewController.checkout,
//                    initialAddresses: addresses.filter { $0.pickupPoint == nil } .map { $0 },
//                    initialSelectedAddress: viewController.checkoutViewModel.selectedBillingAddress)
//                addressSelectionViewController.addressUpdatedHandler = { viewController.checkoutViewModel.addressUpdated($0) }
//                addressSelectionViewController.addressDeletedHandler = { viewController.checkoutViewModel.addressDeleted($0) }
//                addressSelectionViewController.addressSelectedHandler = { viewController.checkoutViewModel.selectedBillingAddress = $0 }
//                addressSelectionViewController.addressCreationStrategy =  BillingAddressCreationStrategy()
//                addressSelectionViewController.title = Localizer.string("addressListView.title.billing")
//                viewController.showViewController(addressSelectionViewController, sender: nil)
//            }
//        }
//    }
//
//}
//
//extension UpdateCheckoutRequest {
//
//    init (checkoutViewModel: CheckoutViewModel) {
//        self.init(billingAddressId: checkoutViewModel.selectedBillingAddress?.id,
//            shippingAddressId: checkoutViewModel.selectedShippingAddress?.id)
//    }
//
//}
