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
            updateDataModel(addresses: addresses)
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

    fileprivate var hasAddresses: Bool {
        return shippingAddress != nil && billingAddress != nil
    }

    static func createInstance(_ customer: Customer, selectedUnit: SelectedArticleUnit,
                               completion: @escaping LoggedInSummaryActionHandlerCompletion) {
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
            let callbackURL = AtlasAPIClient.shared?.config.payment.selectionCallbackURL
            else {
            let error: AtlasCheckoutError = !hasAddresses ? .missingAddress : .unclassified
            UserMessage.displayError(error)
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

        AtlasUIViewController.shared?.mainNavigationController.pushViewController(paymentViewController, animated: true)
    }

    func showShippingAddressSelectionScreen() {
        AtlasUIClient.addresses { [weak self] result in
            guard let userAddresses = result.process() else { return }
            let addresses: [EquatableAddress] = userAddresses.map { $0 }
            let creationStrategy = ShippingAddressViewModelCreationStrategy()
            let addressViewController = AddressListViewController(initialAddresses: addresses, selectedAddress: self?.shippingAddress)
            addressViewController.addressUpdatedHandler = { self?.updated(address: $0) }
            addressViewController.addressDeletedHandler = { self?.deleted(address: $0) }
            addressViewController.addressSelectedHandler = { self?.select(shippingAddress: $0) }
            addressViewController.actionHandler = LoggedInAddressListActionHandler(addressViewModelCreationStrategy: creationStrategy)
            addressViewController.title = Localizer.string("addressListView.title.shipping")
            AtlasUIViewController.shared?.mainNavigationController.pushViewController(addressViewController, animated: true)
        }
    }

    func showBillingAddressSelectionScreen() {
        AtlasUIClient.addresses { [weak self] result in
            guard let userAddresses = result.process() else { return }
            let addresses: [EquatableAddress] = userAddresses.filter { $0.pickupPoint == nil } .map { $0 }
            let creationStrategy = BillingAddressViewModelCreationStrategy()
            let addressViewController = AddressListViewController(initialAddresses: addresses, selectedAddress: self?.billingAddress)
            addressViewController.addressUpdatedHandler = { self?.updated(address: $0) }
            addressViewController.addressDeletedHandler = { self?.deleted(address: $0) }
            addressViewController.addressSelectedHandler = { self?.select(billingAddress: $0) }
            addressViewController.actionHandler = LoggedInAddressListActionHandler(addressViewModelCreationStrategy: creationStrategy)
            addressViewController.title = Localizer.string("addressListView.title.billing")
            AtlasUIViewController.shared?.mainNavigationController.pushViewController(addressViewController, animated: true)
        }
    }

}

extension LoggedInSummaryActionHandler {

    fileprivate func handleOrderConfirmation(_ order: Order) {
        guard let paymentURL = order.externalPaymentURL else {
            showConfirmationScreen(order)
            return
        }

        guard let callbackURL = AtlasAPIClient.shared?.config.payment.thirdPartyCallbackURL else {
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
        AtlasUIViewController.shared?.mainNavigationController.pushViewController(paymentViewController, animated: true)
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

    fileprivate func updateDataModel(addresses: CheckoutAddresses?, usingCartCheckout: Bool = false) {
        guard let selectedArticleUnit = dataSource?.dataModel.selectedArticleUnit else { return }

        let dataModel: CheckoutSummaryDataModel
        if usingCartCheckout {
            dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit, cartCheckout: cartCheckout, addresses: addresses)
        } else {
            dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit, cartCheckout: nil, addresses: addresses)
        }
        delegate?.updated(dataModel: dataModel)

        if usingCartCheckout && cartCheckout?.checkout == nil && hasAddresses {
            createCartCheckout { [weak self] result in
                guard let cartCheckout = result.process() else { return }
                self?.cartCheckout = cartCheckout
            }
        }
    }

}

extension LoggedInSummaryActionHandler {

    fileprivate func updated(address: EquatableAddress) {
        if let shippingAddress = shippingAddress, shippingAddress == address {
            select(shippingAddress: address)
        }
        if let billingAddress = billingAddress, billingAddress == address {
            select(billingAddress: address)
        }
    }

    fileprivate func deleted(address: EquatableAddress) {
        if let shippingAddress = shippingAddress, shippingAddress == address {
            updateDataModel(addresses: CheckoutAddresses(billingAddress: billingAddress, shippingAddress: nil), usingCartCheckout: false)
            cartCheckout?.checkout = nil
        }
        if let billingAddress = billingAddress, billingAddress == address {
            updateDataModel(addresses: CheckoutAddresses(billingAddress: nil, shippingAddress: shippingAddress), usingCartCheckout: false)
            cartCheckout?.checkout = nil
        }
    }

    fileprivate func select(shippingAddress address: EquatableAddress?) {
        updateDataModel(addresses: CheckoutAddresses(billingAddress: billingAddress, shippingAddress: address))
    }

    fileprivate func select(billingAddress address: EquatableAddress?) {
        updateDataModel(addresses: CheckoutAddresses(billingAddress: address, shippingAddress: shippingAddress))
    }

}
