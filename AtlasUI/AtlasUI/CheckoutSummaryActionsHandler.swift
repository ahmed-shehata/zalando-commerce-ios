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
        let mainViewController: AtlasUIViewController? = try? Atlas.provide()
        guard let
            atlasUIViewController = mainViewController,
            viewController = self.viewController else { return }

        viewController.displayLoader { done in
            viewController.checkout.client.createCheckoutCart(for: viewController.checkoutViewModel.selectedArticleUnit,
            addresses: viewController.checkoutViewModel.selectedAddresses) { result in
                done()
                guard let (checkout, cart) = result.process() else { return }

                let checkoutViewModel = CheckoutViewModel(
                    selectedArticleUnit: viewController.checkoutViewModel.selectedArticleUnit,
                    cart: cart,
                    checkout: checkout)
                viewController.checkoutViewModel = checkoutViewModel

                if viewController.viewState == .CheckoutReady && !atlasUIViewController.errorDisplayed {
                    self.createOrder(forCheckoutId: checkout.id)
                }
            }
        }
    }

    internal func createOrder(forCheckoutId checkoutId: String) {
        guard let viewController = self.viewController else { return }
        viewController.displayLoader { hideLoader in
            viewController.checkout.client.createOrder(checkoutId) { result in
                hideLoader()
                guard let order = result.process() else { return }
                self.handleOrderConfirmation(order)
            }
        }
    }

}

extension CheckoutSummaryActionsHandler {

    internal func loadCustomerData() {
        guard let viewController = self.viewController else { return }

        viewController.checkout.client.customer { result in

            guard let customer = result.process() else { return }
            self.generateCheckout(customer)
        }
    }

    private func generateCheckout(customer: Customer) {
        guard let viewController = self.viewController else { return }

        viewController.displayLoader { done in
            viewController.checkout.createCheckoutViewModel(fromModel: viewController.checkoutViewModel) { result in
                done()
                guard var checkoutViewModel = result.process() else { return }

                checkoutViewModel.customer = customer
                viewController.checkoutViewModel = checkoutViewModel
            }
        }
    }

}

extension CheckoutSummaryActionsHandler {

    internal func showPaymentSelectionScreen() {
        guard let viewController = self.viewController else { return }
        guard Atlas.isUserLoggedIn() else { return loadCustomerData() }
        guard let paymentURL = viewController.checkoutViewModel.checkout?.payment.selectionPageURL else {
            if viewController.checkoutViewModel.selectedShippingAddress == nil ||
                viewController.checkoutViewModel.selectedBillingAddress == nil {
                let atlasUIViewController: AtlasUIViewController? = try? Atlas.provide()
                atlasUIViewController?.displayError(AtlasCatalogError.missingAddress)
            }
            return
        }

        let paymentSelectionViewController = PaymentSelectionViewController(paymentSelectionURL: paymentURL)
        paymentSelectionViewController.paymentCompletion = { result in

            guard let _ = result.process() else { return }
            self.loadCustomerData()
        }
        viewController.showViewController(paymentSelectionViewController, sender: viewController)
    }

    internal func showShippingAddressSelectionScreen() {
        guard let viewController = self.viewController else { return }
        guard Atlas.isUserLoggedIn() else { return loadCustomerData() }

        viewController.displayLoader { done in
            viewController.checkout.client.addresses { result in
                done()
                guard let addresses = result.process() else { return }
                let addressSelectionViewController = AddressPickerViewController(checkout: viewController.checkout,
                    initialAddresses: addresses.map { $0 },
                    initialSelectedAddress: viewController.checkoutViewModel.selectedShippingAddress)
                addressSelectionViewController.addressUpdatedHandler = self.addressUpdatedHandler
                addressSelectionViewController.addressDeletedHandler = self.addressDeletedHandler
                addressSelectionViewController.addressSelectedHandler = { viewController.checkoutViewModel.selectedShippingAddress = $0 }
                addressSelectionViewController.createAddressViewControllerGenerator = { handler in

                }
                viewController.showViewController(addressSelectionViewController, sender: nil)
            }
        }
    }

    internal func showBillingAddressSelectionScreen() {
        guard let viewController = self.viewController else { return }
        guard Atlas.isUserLoggedIn() else { return loadCustomerData() }

        viewController.displayLoader { done in
            viewController.checkout.client.addresses { result in
                done()
                guard let addresses = result.process() else { return }
                let addressSelectionViewController = AddressPickerViewController(checkout: viewController.checkout,
                    initialAddresses: addresses.map { $0 },
                    initialSelectedAddress: viewController.checkoutViewModel.selectedBillingAddress)
                addressSelectionViewController.addressUpdatedHandler = self.addressUpdatedHandler
                addressSelectionViewController.addressDeletedHandler = self.addressDeletedHandler
                addressSelectionViewController.addressSelectedHandler = { viewController.checkoutViewModel.selectedBillingAddress = $0 }
                addressSelectionViewController.createAddressViewControllerGenerator = { handler in
                    let viewController = AddressFormViewController(addressType: type,
                        addressMode: .createAddress,
                        checkout: checkout,
                        completion: completion)
                }
                viewController.showViewController(addressSelectionViewController, sender: nil)
            }
        }
    }

//    private func configureCreateAddress() {
//        tableviewDelegate?.createAddressHandler = { [weak self] in
//            guard let strongSelf = self else { return }
//            guard strongSelf.addressType == .shipping else {
//                strongSelf.showCreateAddress(.StandardAddress)
//                return
//            }
//
//            let title = Localizer.string("Address.Add.type.title")
//            let standardAction = ButtonAction(text: "Address.Add.type.standard", style: .Default) { (UIAlertAction) in
//                strongSelf.showCreateAddress(.StandardAddress)
//            }
//            let pickupPointAction = ButtonAction(text: "Address.Add.type.pickupPoint", style: .Default) { (UIAlertAction) in
//                strongSelf.showCreateAddress(.PickupPoint)
//            }
//            let cancelAction = ButtonAction(text: "Cancel", style: .Cancel, handler: nil)
//
//            UserMessage.show(title: title,
//                             preferredStyle: .ActionSheet,
//                             actions: standardAction, pickupPointAction, cancelAction)
//        }
//    }
//
//    private func showCreateAddress(addressType: AddressFormType) {
//        showCreateAddressViewController(addressType) { [weak self] address in
//            guard let strongSelf = self else { return }
//            strongSelf.selectionCompletion(pickedAddress: address,
//                                           pickedAddressType: strongSelf.addressType,
//                                           popBackToSummaryOnFinish: true)
//            strongSelf.navigationController?.popViewControllerAnimated(false)
//        }
//    }
//
//    private func showCreateAddressViewController(type: AddressFormType, completion: AddressFormCompletion) {
//        let viewController = AddressFormViewController(addressType: type,
//                                                       addressMode: .createAddress,
//                                                       checkout: checkout,
//                                                       completion: completion)
//        let navigationController = UINavigationController(rootViewController: viewController)
//        navigationController.modalPresentationStyle = .OverCurrentContext
//        self.navigationController?.showViewController(navigationController, sender: nil)
//    }

    internal func handleOrderConfirmation(order: Order) {
        guard let viewController = self.viewController else { return }

        guard let paymentURL = order.externalPaymentURL else {
            viewController.viewState = .OrderPlaced
            return
        }

        let paymentSelectionViewController = PaymentSelectionViewController(paymentSelectionURL: paymentURL)
        paymentSelectionViewController.paymentCompletion = { result in
            guard let _ = result.process() else { return }
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
                viewController.checkoutViewModel.checkout = nil
            }

            switch addressType {
            case .billing:
                viewController.checkoutViewModel.selectedBillingAddress = address
            case .shipping:
                viewController.checkoutViewModel.selectedShippingAddress = address
            }

            guard viewController.checkoutViewModel.isReadyToCreateCheckout else { return }

            viewController.displayLoader { done in
                viewController.checkout.createCheckoutViewModel(fromModel: viewController.checkoutViewModel) { result in
                    done()
                    guard let checkoutViewModel = result.process() else { return }

                    viewController.checkoutViewModel = checkoutViewModel
                }
            }
    }

    func addressUpdatedHandler(address: EquatableAddress) {
        guard let viewController = viewController else { return }

        if let billingAddress = viewController.checkoutViewModel.selectedBillingAddress where  billingAddress == address {
            viewController.checkoutViewModel.selectedBillingAddress = address
        }
        if let shippingAddress = viewController.checkoutViewModel.selectedShippingAddress where  shippingAddress == address {
            viewController.checkoutViewModel.selectedShippingAddress = address
        }
    }

    func addressDeletedHandler(address: EquatableAddress) {
        guard let viewController = viewController else { return }

        if let billingAddress = viewController.checkoutViewModel.selectedBillingAddress where  billingAddress == address {
            viewController.checkoutViewModel.selectedBillingAddress = nil
        }
        if let shippingAddress = viewController.checkoutViewModel.selectedShippingAddress where  shippingAddress == address {
            viewController.checkoutViewModel.selectedShippingAddress = nil
        }
    }

}

extension UpdateCheckoutRequest {

    init (checkoutViewModel: CheckoutViewModel) {
        self.init(billingAddressId: checkoutViewModel.selectedBillingAddress?.id,
            shippingAddressId: checkoutViewModel.selectedShippingAddress?.id)
    }

}
