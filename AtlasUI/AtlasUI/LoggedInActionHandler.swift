//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

typealias LoggedInActionHandlerCompletion = AtlasResult<LoggedInActionHandler> -> Void
typealias CartCheckout = (cart: Cart?, checkout: Checkout?)
typealias CreateCartCheckoutCompletion = AtlasResult<CartCheckout> -> Void

struct LoggedInActionHandler: CheckoutSummaryActionHandler {

    let customer: Customer
    var cartCheckout: CartCheckout? {
        didSet {
            updateDataModel()
        }
    }
    let uiModel: CheckoutSummaryUIModel = LoggedInUIModel()
    weak var delegate: CheckoutSummaryActionHandlerDelegate?

    static func createInstance(customer: Customer, selectedArticleUnit: SelectedArticleUnit, completion: LoggedInActionHandlerCompletion) {
        var actionHandler = LoggedInActionHandler(customer: customer, cartCheckout: nil, delegate: nil)
        LoggedInActionHandler.createCartCheckout(selectedArticleUnit) { result in
            switch result {
            case .success(let cartCheckout):
                actionHandler.cartCheckout = cartCheckout
                completion(.success(actionHandler))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    mutating func handleSubmitButton() {
        guard let delegate = delegate else { return }
        guard delegate.viewModel.dataModel.isPaymentSelected else {
            UserMessage.displayError(AtlasCheckoutError.missingAddressAndPayment)
            return
        }

        createCartCheckout { result in
            guard let cartCheckout = result.process() else { return }
            guard let
                cart = cartCheckout.cart,
                checkout = cartCheckout.checkout
                else {
                    return UserMessage.displayError(AtlasCheckoutError.unclassified)
            }

            self.cartCheckout = CartCheckout(cart: cart, checkout: checkout)

            if delegate.viewModel.dataModel.isPaymentSelected && !UserMessage.errorDisplayed {
                AtlasAPIClient.createOrder(checkout.id) { result in
                    guard let order = result.process() else { return }

                    let selectedArticleUnit = delegate.viewModel.dataModel.selectedArticleUnit
                    let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit, checkout: checkout, order: order)
                    delegate.actionHandler = OrderPlacedActionHandler()
                    delegate.viewModel.dataModel = dataModel
                }
            }
        }
    }

    mutating func showPaymentSelectionScreen() {
        print(self.cartCheckout)
        guard let
            paymentURL = cartCheckout?.checkout?.payment.selectionPageURL,
            callbackURL = AtlasAPIClient.instance?.config.payment.selectionCallbackURL
            else {
                if delegate?.viewModel.dataModel.shippingAddress == nil || delegate?.viewModel.dataModel.billingAddress == nil {
                    UserMessage.displayError(AtlasCheckoutError.missingAddress)
                } else {
                    UserMessage.displayError(AtlasCheckoutError.unclassified)
                }
                return
        }

        let paymentViewController = PaymentViewController(paymentURL: paymentURL, callbackURL: callbackURL)
        paymentViewController.paymentCompletion = { result in
            guard let paymentStatus = result.process() else { return }
            switch paymentStatus {
            case .redirect, .success:
                self.createCartCheckout { result in
                    guard let cartCheckout = result.process() else { return }
                    self.cartCheckout = cartCheckout
                }
            case .cancel:
                break
            case .error:
                UserMessage.displayError(AtlasCheckoutError.unclassified)
            }
        }

        AtlasUIViewController.instance?.mainNavigationController.pushViewController(paymentViewController, animated: true)
    }

    mutating func showShippingAddressSelectionScreen() {
        AtlasAPIClient.addresses { result in
            guard let userAddresses = result.process() else { return }
            let addresses: [EquatableAddress] = userAddresses.map { $0 }
            let selectedAddress = self.delegate?.viewModel.dataModel.shippingAddress as? EquatableAddress
            let addressViewController = AddressPickerViewController(initialAddresses: addresses, initialSelectedAddress: selectedAddress)
            addressViewController.addressUpdatedHandler = { self.addressUpdated($0) }
            addressViewController.addressDeletedHandler = { self.addressDeleted($0) }
            addressViewController.addressSelectedHandler = { self.selectShippingAddress($0) }
            addressViewController.addressCreationStrategy = ShippingAddressCreationStrategy()
            addressViewController.title = Localizer.string("addressListView.title.shipping")
            AtlasUIViewController.instance?.mainNavigationController.pushViewController(addressViewController, animated: true)
        }
    }

    mutating func showBillingAddressSelectionScreen() {
        AtlasAPIClient.addresses { result in
            guard let userAddresses = result.process() else { return }
            let addresses: [EquatableAddress] = userAddresses.map { $0 }
            let selectedAddress = self.delegate?.viewModel.dataModel.billingAddress as? EquatableAddress
            let addressViewController = AddressPickerViewController(initialAddresses: addresses, initialSelectedAddress: selectedAddress)
            addressViewController.addressUpdatedHandler = { self.addressUpdated($0) }
            addressViewController.addressDeletedHandler = { self.addressDeleted($0) }
            addressViewController.addressSelectedHandler = { self.selectBillingAddress($0) }
            addressViewController.addressCreationStrategy = BillingAddressCreationStrategy()
            addressViewController.title = Localizer.string("addressListView.title.billing")
            AtlasUIViewController.instance?.mainNavigationController.pushViewController(addressViewController, animated: true)
        }
    }

}

extension LoggedInActionHandler {

    private func createCartCheckout(completion: CreateCartCheckoutCompletion) {
        guard let selectedArticleUnit = delegate?.viewModel.dataModel.selectedArticleUnit else { return }

        let addresses = delegate?.viewModel.dataModel.addresses
        LoggedInActionHandler.createCartCheckout(selectedArticleUnit, addresses: addresses, completion: completion)
    }

    private static func createCartCheckout(selectedArticleUnit: SelectedArticleUnit,
                                           addresses: CheckoutAddresses? = nil,
                                           completion: CreateCartCheckoutCompletion) {

        AtlasAPIClient.createCheckoutCart(selectedArticleUnit.sku, addresses: addresses) { result in
            switch result {
            case .failure(let error):
                if case let AtlasAPIError.checkoutFailed(cart, _) = error {
                    completion(.success((cart: cart, checkout: nil)))
                    if addresses?.billingAddress != nil && addresses?.shippingAddress != nil {
                        UserMessage.displayError(AtlasCheckoutError.checkoutFailure)
                    }
                } else {
                    completion(.failure(error))
                }
            case .success(let checkoutCart):
                completion(.success((cart: checkoutCart.cart, checkout: checkoutCart.checkout)))
            }
        }
    }

}

extension LoggedInActionHandler {

    private mutating func updateDataModel() {
        let shippingAddress = delegate?.viewModel.dataModel.shippingAddress
        let billingAddress = delegate?.viewModel.dataModel.billingAddress
        updateDataModel(shippingAddress: shippingAddress, billingAddress: billingAddress)
    }

    private mutating func updateDataModel(shippingAddress shippingAddress: FormattableAddress?, billingAddress: FormattableAddress?) {
        guard let selectedArticleUnit = delegate?.viewModel.dataModel.selectedArticleUnit else { return }

        print(self.cartCheckout)
        delegate?.viewModel.dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit,
                                                                 cartCheckout: cartCheckout,
                                                                 shippingAddress: shippingAddress,
                                                                 billingAddress: billingAddress)

        if cartCheckout?.checkout == nil &&
            delegate?.viewModel.dataModel.shippingAddress != nil &&
            delegate?.viewModel.dataModel.billingAddress != nil {

            createCartCheckout { result in
                guard let cartCheckout = result.process() else { return }
                print(cartCheckout)
                self.cartCheckout = cartCheckout
                Async.delay(0.5, block: {
                    print(self.cartCheckout)
                })
                print(self.cartCheckout)
            }
        }
    }

    private mutating func addressUpdated(address: EquatableAddress) {
        if let shippingAddress = delegate?.viewModel.dataModel.shippingAddress as? EquatableAddress where shippingAddress == address {
            selectShippingAddress(shippingAddress)
        }
        if let billingAddress = delegate?.viewModel.dataModel.billingAddress as? EquatableAddress where billingAddress == address {
            selectBillingAddress(billingAddress)
        }
    }

    private mutating func addressDeleted(address: EquatableAddress) {
        if let shippingAddress = delegate?.viewModel.dataModel.shippingAddress as? EquatableAddress where shippingAddress == address {
            cartCheckout?.checkout = nil
            selectShippingAddress(nil)
        }
        if let billingAddress = delegate?.viewModel.dataModel.billingAddress as? EquatableAddress where billingAddress == address {
            cartCheckout?.checkout = nil
            selectBillingAddress(nil)
        }
    }

    private mutating func selectShippingAddress(address: EquatableAddress?) {
        let billingAddress = delegate?.viewModel.dataModel.billingAddress
        updateDataModel(shippingAddress: address, billingAddress: billingAddress)
    }

    private mutating func selectBillingAddress(address: EquatableAddress?) {
        let shippingAddress = delegate?.viewModel.dataModel.shippingAddress
        updateDataModel(shippingAddress: shippingAddress, billingAddress: address)
    }

}
