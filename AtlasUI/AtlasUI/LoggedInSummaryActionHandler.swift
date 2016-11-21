//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

typealias LoggedInSummaryActionHandlerCompletion = (AtlasResult<LoggedInSummaryActionHandler>) -> Void
typealias CartCheckout = (cart: Cart?, checkout: Checkout?)
typealias CreateCartCheckoutCompletion = (AtlasResult<CartCheckout>) -> Void

class LoggedInSummaryActionHandler: CheckoutSummaryActionHandler {

    let customer: Customer

    weak var dataSource: CheckoutSummaryActionHandlerDataSource?
    weak var delegate: CheckoutSummaryActionHandlerDelegate?

    var cartCheckout: CartCheckout? {
        didSet {
            updateDataModel(addresses)
        }
    }

    fileprivate var shippingAddress: EquatableAddress? {
        return dataSource?.dataModel.shippingAddress as? EquatableAddress
    }
    fileprivate var billingAddress: EquatableAddress? {
        return dataSource?.dataModel.billingAddress as? EquatableAddress
    }
    fileprivate var addresses: CheckoutAddresses? {
        return CheckoutAddresses(billingAddress: billingAddress, shippingAddress: shippingAddress)
    }

    static func createInstance(_ customer: Customer, selectedUnit: SelectedArticleUnit, completion: @escaping LoggedInSummaryActionHandlerCompletion) {
        let actionHandler = LoggedInSummaryActionHandler(customer: customer)
        LoggedInSummaryActionHandler.createCartCheckout(selectedUnit) { result in
            switch result {
            case .success(let cartCheckout):
                actionHandler.cartCheckout = cartCheckout
                completion(.success(actionHandler))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    fileprivate init(customer: Customer) {
        self.customer = customer
    }

    func handleSubmitButton() {
        guard let dataSource = dataSource else { return }
        guard dataSource.dataModel.isPaymentSelected else {
            UserMessage.displayError(AtlasCheckoutError.missingAddressAndPayment)
            return
        }

        createCartCheckout { [weak self] result in
            guard let cartCheckout = result.process() else { return }
            guard let checkout = cartCheckout.checkout, cartCheckout.cart != nil else {
                return UserMessage.displayError(AtlasCheckoutError.unclassified)
            }

            self?.cartCheckout = cartCheckout

            if dataSource.dataModel.isPaymentSelected && !UserMessage.errorDisplayed {
                AtlasUIClient.createOrder(checkout.id) { result in
                    guard let order = result.process() else { return }
                    self?.handleOrderConfirmation(order)
                }
            }
        }
    }

    func showPaymentSelectionScreen() {
        guard let paymentURL = cartCheckout?.checkout?.payment.selectionPageURL,
            let callbackURL = AtlasAPIClient.instance?.config.payment.selectionCallbackURL
            else {
                if shippingAddress == nil || billingAddress == nil {
                    UserMessage.displayError(AtlasCheckoutError.missingAddress)
                } else {
                    UserMessage.displayError(AtlasCheckoutError.unclassified)
                }
                return
        }

        let paymentViewController = PaymentViewController(paymentURL: paymentURL, callbackURL: callbackURL)
        paymentViewController.paymentCompletion = { [weak self] paymentStatus in
            switch paymentStatus {
            case .redirect, .success:
                self?.createCartCheckout { result in
                    guard let cartCheckout = result.process() else { return }
                    self?.cartCheckout = cartCheckout
                }
            case .cancel:
                break
            case .error:
                UserMessage.displayError(AtlasCheckoutError.unclassified)
            }
        }

        AtlasUIViewController.instance?.mainNavigationController.pushViewController(paymentViewController, animated: true)
    }

    func showShippingAddressSelectionScreen() {
        AtlasUIClient.addresses { [weak self] result in
            guard let userAddresses = result.process() else { return }
            let addresses: [EquatableAddress] = userAddresses.map { $0 }
            let creationStrategy = ShippingAddressViewModelCreationStrategy()
            let addressViewController = AddressListViewController(initialAddresses: addresses, selectedAddress: self?.shippingAddress)
            addressViewController.addressUpdatedHandler = { self?.addressUpdated($0) }
            addressViewController.addressDeletedHandler = { self?.addressDeleted($0) }
            addressViewController.addressSelectedHandler = { self?.selectShippingAddress($0) }
            addressViewController.actionHandler = LoggedInAddressListActionHandler(addressViewModelCreationStrategy: creationStrategy)
            addressViewController.title = Localizer.string("addressListView.title.shipping")
            AtlasUIViewController.instance?.mainNavigationController.pushViewController(addressViewController, animated: true)
        }
    }

    func showBillingAddressSelectionScreen() {
        AtlasUIClient.addresses { [weak self] result in
            guard let userAddresses = result.process() else { return }
            let addresses: [EquatableAddress] = userAddresses.filter { $0.pickupPoint == nil } .map { $0 }
            let creationStrategy = BillingAddressViewModelCreationStrategy()
            let addressViewController = AddressListViewController(initialAddresses: addresses, selectedAddress: self?.billingAddress)
            addressViewController.addressUpdatedHandler = { self?.addressUpdated($0) }
            addressViewController.addressDeletedHandler = { self?.addressDeleted($0) }
            addressViewController.addressSelectedHandler = { self?.selectBillingAddress($0) }
            addressViewController.actionHandler = LoggedInAddressListActionHandler(addressViewModelCreationStrategy: creationStrategy)
            addressViewController.title = Localizer.string("addressListView.title.billing")
            AtlasUIViewController.instance?.mainNavigationController.pushViewController(addressViewController, animated: true)
        }
    }

}

extension LoggedInSummaryActionHandler {

    fileprivate func handleOrderConfirmation(_ order: Order) {
        guard let paymentURL = order.externalPaymentURL else {
            showConfirmationScreen(order)
            return
        }

        guard let callbackURL = AtlasAPIClient.instance?.config.payment.thirdPartyCallbackURL else {
            UserMessage.displayError(AtlasCheckoutError.unclassified)
            return
        }

        let paymentViewController = PaymentViewController(paymentURL: paymentURL, callbackURL: callbackURL)
        paymentViewController.paymentCompletion = { [weak self] paymentStatus in
            switch paymentStatus {
            case .success: self?.showConfirmationScreen(order)
            case .redirect, .cancel: break
            case .error: UserMessage.displayError(AtlasCheckoutError.unclassified)
            }
        }
        AtlasUIViewController.instance?.mainNavigationController.pushViewController(paymentViewController, animated: true)
    }

    fileprivate func showConfirmationScreen(_ order: Order) {
        guard let dataSource = dataSource, let delegate = delegate else { return }
        let selectedArticleUnit = dataSource.dataModel.selectedArticleUnit
        let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit, checkout: cartCheckout?.checkout, order: order)
        delegate.updated(actionHandler: OrderPlacedSummaryActionHandler())
        delegate.updated(dataModel: dataModel)
        delegate.updated(layout: OrderPlacedLayout())
    }

}

extension LoggedInSummaryActionHandler {

    fileprivate func createCartCheckout(_ completion: @escaping CreateCartCheckoutCompletion) {
        guard let selectedArticleUnit = dataSource?.dataModel.selectedArticleUnit else { return }
        LoggedInSummaryActionHandler.createCartCheckout(selectedArticleUnit, addresses: addresses, completion: completion)
    }

    fileprivate static func createCartCheckout(_ selectedArticleUnit: SelectedArticleUnit,
                                           addresses: CheckoutAddresses? = nil,
                                           completion: @escaping CreateCartCheckoutCompletion) {

        AtlasUIClient.createCheckoutCart(selectedArticleUnit.sku, addresses: addresses) { result in
            switch result {
            case .failure(let error, _):
                guard case let AtlasAPIError.checkoutFailed(cart, _) = error else {
                    completion(.failure(error))
                    return
                }

                completion(.success((cart: cart, checkout: nil)))
                if addresses?.billingAddress != nil && addresses?.shippingAddress != nil {
                    UserMessage.displayError(AtlasCheckoutError.checkoutFailure)
                }
            case .success(let checkoutCart):
                completion(.success((cart: checkoutCart.cart, checkout: checkoutCart.checkout)))
            }
        }
    }

}

extension LoggedInSummaryActionHandler {

    fileprivate func updateDataModel(_ addresses: CheckoutAddresses?) {
        guard let selectedArticleUnit = dataSource?.dataModel.selectedArticleUnit else { return }

        let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit, cartCheckout: cartCheckout, addresses: addresses)
        delegate?.updated(dataModel: dataModel)

        if cartCheckout?.checkout == nil && shippingAddress != nil && billingAddress != nil {
            createCartCheckout { [weak self] result in
                guard let cartCheckout = result.process() else { return }
                self?.cartCheckout = cartCheckout
            }
        }
    }

    fileprivate func updateDataModelWithNoCartCheckout(_ addresses: CheckoutAddresses) {
        guard let selectedArticleUnit = dataSource?.dataModel.selectedArticleUnit else { return }

        let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit, cartCheckout: nil, addresses: addresses)
        delegate?.updated(dataModel: dataModel)
    }

}

extension LoggedInSummaryActionHandler {

    fileprivate func addressUpdated(_ address: EquatableAddress) {
        if let shippingAddress = shippingAddress, shippingAddress == address {
            selectShippingAddress(address)
        }
        if let billingAddress = billingAddress, billingAddress == address {
            selectBillingAddress(address)
        }
    }

    fileprivate func addressDeleted(_ address: EquatableAddress) {
        if let shippingAddress = shippingAddress, shippingAddress == address {
            updateDataModelWithNoCartCheckout(CheckoutAddresses(billingAddress: billingAddress, shippingAddress: nil))
            cartCheckout?.checkout = nil
        }
        if let billingAddress = billingAddress, billingAddress == address {
            updateDataModelWithNoCartCheckout(CheckoutAddresses(billingAddress: nil, shippingAddress: shippingAddress))
            cartCheckout?.checkout = nil
        }
    }

    fileprivate func selectShippingAddress(_ address: EquatableAddress?) {
        updateDataModel(CheckoutAddresses(billingAddress: billingAddress, shippingAddress: address))
    }

    fileprivate func selectBillingAddress(_ address: EquatableAddress?) {
        updateDataModel(CheckoutAddresses(billingAddress: address, shippingAddress: shippingAddress))
    }

}
