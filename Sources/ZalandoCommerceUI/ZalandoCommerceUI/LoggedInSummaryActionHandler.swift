//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import ZalandoCommerceAPI

class LoggedInSummaryActionHandler: CheckoutSummaryActionHandler {

    let customer: Customer
    weak var dataSource: CheckoutSummaryActionHandlerDataSource?
    weak var delegate: CheckoutSummaryActionHandlerDelegate?
    var dataModelDisplayedError: Error?

    var coupon: String?
    var cartCheckout: CartCheckout {
        didSet {
            updateCheckout()
        }
    }

    fileprivate var addressCreationStrategy: AddressViewModelCreationStrategy?

    static func create(customer: Customer, selectedArticle: SelectedArticle,
                       completion: @escaping ResultCompletion<LoggedInSummaryActionHandler>) {
        LoggedInSummaryActionHandler.createCartCheckout(selectedArticle: selectedArticle, coupon: nil) { result in
            switch result {
            case .success(let cartCheckout):
                let actionHandler = LoggedInSummaryActionHandler(customer: customer, cartCheckout: cartCheckout)
                completion(.success(actionHandler))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    fileprivate init(customer: Customer, cartCheckout: CartCheckout) {
        self.customer = customer
        self.cartCheckout = cartCheckout
    }

    func handleSubmit() {
        guard let dataSource = dataSource else { return }
        guard shippingAddress != nil, billingAddress != nil else {
            UserError.display(error: CheckoutError.missingAddress)
            return
        }
        guard dataSource.dataModel.isPaymentSelected else {
            UserError.display(error: CheckoutError.missingPaymentMethod)
            return
        }

        createCartCheckout { [weak self] result in
            guard let cartCheckout = result.process() else { return }
            guard let checkout = cartCheckout.checkout else {
                return UserError.display(error: CheckoutError.unclassified)
            }

            self?.cartCheckout = cartCheckout

            if dataSource.dataModel.isPaymentSelected && self?.dataModelDisplayedError == nil {
                ZalandoCommerceAPI.withLoader.createOrder(from: checkout) { result in
                    guard let order = result.process() else { return }
                    self?.handleConfirmation(forOrder: order)
                }
            }
        }
    }

    func handlePaymentSelection() {
        guard let paymentURL = cartCheckout.checkout?.payment.selectionPageURL,
            let callbackURL = Config.shared?.payment.selectionCallbackURL else {
                let error = !hasAddresses ? CheckoutError.missingAddress : CheckoutError.unclassified
                UserError.display(error: error)
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
            case .error, .guestRedirect:
                UserError.display(error: CheckoutError.unclassified)
            }
        }

        ZalandoCommerceUIViewController.push(paymentViewController)
    }

    func handleShippingAddressSelection() {
        ZalandoCommerceAPI.withLoader.addresses { [weak self] result in
            guard let userAddresses = result.process() else { return }
            let addresses: [EquatableAddress] = userAddresses.map { $0 }
            if !addresses.isEmpty {
                self?.showAddressListViewController(forShippingAddressWithAddresses: addresses)
            } else {
                self?.showCreateAddressForm(strategy: ShippingAddressViewModelCreationStrategy()) { [weak self] newAddress in
                    self?.select(shippingAddress: newAddress)
                }
            }
        }
    }

    func handleBillingAddressSelection() {
        ZalandoCommerceAPI.withLoader.addresses { [weak self] result in
            guard let userAddresses = result.process() else { return }
            let addresses: [EquatableAddress] = userAddresses.filter { $0.isBillingAllowed } .map { $0 }
            if !addresses.isEmpty {
                self?.showAddressListViewController(forBillingAddressWithAddresses: addresses)
            } else {
                self?.showCreateAddressForm(strategy: BillingAddressViewModelCreationStrategy()) { [weak self] newAddress in
                    self?.select(billingAddress: newAddress)
                }
            }
        }
    }

    func handleCouponChanges(coupon: String?) {
        self.coupon = coupon
        createCartCheckout { [weak self] result in
            guard let cartCheckout = result.process() else {
                self?.coupon = nil
                return
            }

            self?.cartCheckout = cartCheckout
        }
    }

    func updated(selectedArticle: SelectedArticle) {
        let dataModel = CheckoutSummaryDataModel(selectedArticle: selectedArticle,
                                                 shippingAddress: shippingAddress,
                                                 billingAddress: billingAddress,
                                                 totalPrice: selectedArticle.totalPrice)
        try? delegate?.updated(dataModel: dataModel)

        if hasAddresses {
            createCartCheckout { [weak self] result in
                guard let cartCheckout = result.process() else { return }
                self?.cartCheckout = cartCheckout
            }
        }
    }

}

// MARK: – Address Screen
extension LoggedInSummaryActionHandler {

    fileprivate func showAddressListViewController(forShippingAddressWithAddresses addresses: [EquatableAddress]) {
        let creationStrategy = ShippingAddressViewModelCreationStrategy()
        let addressViewController = AddressListViewController(initialAddresses: addresses, selectedAddress: shippingAddress)
        addressViewController.addressUpdatedHandler = { [weak self] in self?.updated(address: $0) }
        addressViewController.addressDeletedHandler = { [weak self] in self?.deleted(address: $0) }
        addressViewController.addressSelectedHandler = { [weak self] in self?.select(shippingAddress: $0) }
        addressViewController.actionHandler = LoggedInAddressListActionHandler(addressViewModelCreationStrategy: creationStrategy)
        addressViewController.title = Localizer.format(string: "addressListView.title.shipping")
        ZalandoCommerceUIViewController.push(addressViewController)
    }

    fileprivate func showAddressListViewController(forBillingAddressWithAddresses addresses: [EquatableAddress]) {
        let creationStrategy = BillingAddressViewModelCreationStrategy()
        let addressViewController = AddressListViewController(initialAddresses: addresses, selectedAddress: billingAddress)
        addressViewController.addressUpdatedHandler = { [weak self] in self?.updated(address: $0) }
        addressViewController.addressDeletedHandler = { [weak self] in self?.deleted(address: $0) }
        addressViewController.addressSelectedHandler = { [weak self] in self?.select(billingAddress: $0) }
        addressViewController.actionHandler = LoggedInAddressListActionHandler(addressViewModelCreationStrategy: creationStrategy)
        addressViewController.title = Localizer.format(string: "addressListView.title.billing")
        ZalandoCommerceUIViewController.push(addressViewController)
    }

    fileprivate func showCreateAddressForm(strategy: AddressViewModelCreationStrategy, completion: @escaping (EquatableAddress) -> Void) {
        addressCreationStrategy = strategy
        addressCreationStrategy?.titleKey = "guestSummaryView.address.add"
        addressCreationStrategy?.strategyCompletion = { viewModel in
            let actionHandler = LoggedInCreateAddressActionHandler()
            let viewController = AddressFormViewController(viewModel: viewModel, actionHandler: actionHandler) { address, _ in
                completion(address)
            }
            viewController.present()
        }
        addressCreationStrategy?.execute()
    }

}

// MARK: – Handle Confirmation
extension LoggedInSummaryActionHandler {

    fileprivate func handleConfirmation(forOrder order: Order) {
        guard let paymentURL = order.externalPaymentURL else {
            presentConfirmationScreen(for: order)
            return
        }

        guard let callbackURL = Config.shared?.payment.thirdPartyCallbackURL else {
            UserError.display(error: CheckoutError.unclassified)
            return
        }

        let paymentViewController = PaymentViewController(paymentURL: paymentURL, callbackURL: callbackURL)
        paymentViewController.paymentCompletion = { [weak self] paymentStatus in
            switch paymentStatus {
            case .success: self?.presentConfirmationScreen(for: order)
            case .redirect, .cancel: break
            case .error, .guestRedirect: UserError.display(error: CheckoutError.unclassified)
            }
        }
        ZalandoCommerceUIViewController.push(paymentViewController)
    }

    fileprivate func presentConfirmationScreen(for order: Order) {
        guard let dataSource = dataSource, let delegate = delegate else { return }
        let selectedArticle = dataSource.dataModel.selectedArticle
        let dataModel = CheckoutSummaryDataModel(selectedArticle: selectedArticle,
                                                 checkout: cartCheckout.checkout,
                                                 order: order)
        do {
            dataModelDisplayedError = nil
            try delegate.updated(dataModel: dataModel)
        } catch let error {
            dataModelDisplayedError = error
        }
        delegate.updated(layout: OrderPlacedLayout())
        delegate.updated(actionHandler: OrderPlacedSummaryActionHandler())

        let orderConfirmation = OrderConfirmation(order: order, selectedArticle: selectedArticle)
        let result = ZalandoCommerceUI.CheckoutResult.orderPlaced(orderConfirmation: orderConfirmation, customerRequestedArticle: nil)
        ZalandoCommerceUIViewController.presented?.dismissalReason = result
    }

}

// MARK: – Create CartCheckout
extension LoggedInSummaryActionHandler {

    fileprivate func createCartCheckout(completion: @escaping ResultCompletion<CartCheckout>) {
        guard let dataModel = dataSource?.dataModel else { return }
        LoggedInSummaryActionHandler.createCartCheckout(selectedArticle: dataModel.selectedArticle,
                                                        addresses: addresses,
                                                        coupon: coupon,
                                                        completion: completion)
    }

    fileprivate static func createCartCheckout(selectedArticle: SelectedArticle,
                                               addresses: CheckoutAddresses? = nil,
                                               coupon: String?,
                                               completion: @escaping ResultCompletion<CartCheckout>) {

        let coupons = [coupon].flatMap { $0 }
        ZalandoCommerceAPI.withLoader.createCartCheckout(for: selectedArticle, addresses: addresses, coupons: coupons) { result in
            switch result {
            case .failure(let error, _):
                guard case let APIError.checkoutFailed(cart, _) = error else {
                    completion(.failure(error))
                    return
                }

                completion(.success((cart: cart, checkout: nil)))
                if addresses?.billingAddress != nil && addresses?.shippingAddress != nil {
                    UserError.display(error: CheckoutError.checkoutFailure)
                }
            case .success(let checkoutCart):
                completion(.success((cart: checkoutCart.cart, checkout: checkoutCart.checkout)))
            }
        }
    }

}

// MARK: – Update DataModel
extension LoggedInSummaryActionHandler {

    fileprivate func updateCheckout() {
        updateDataModel(with: self.addresses, in: self.cartCheckout)
    }

    fileprivate func update(billingAddress newBillingAddress: BillingAddress? = nil,
                            shippingAddress newShippingAddress: ShippingAddress? = nil) {
        let newAddresses = CheckoutAddresses(shippingAddress: newShippingAddress ?? self.shippingAddress,
                                             billingAddress: newBillingAddress ?? self.billingAddress,
                                             autoFill: true)
        updateDataModel(with: newAddresses, in: self.cartCheckout)
    }

    fileprivate func delete(billingAddress deleteBilling: Bool = false, shippingAddress deleteShipping: Bool = false) {
        let newAddresses = CheckoutAddresses(shippingAddress: deleteShipping ? nil : self.shippingAddress,
                                             billingAddress: deleteBilling ? nil : self.billingAddress)
        updateDataModel(with: newAddresses)
        cartCheckout.checkout = nil
    }

    fileprivate func updateDataModel(with addresses: CheckoutAddresses?, in cartCheckout: CartCheckout? = nil) {
        guard let selectedArticle = dataSource?.dataModel.selectedArticle else { return }

        let addressesChanged = self.addressesChanged(withNewAddresses: addresses)

        let dataModel = CheckoutSummaryDataModel(selectedArticle: selectedArticle, cartCheckout: cartCheckout, addresses: addresses)
        do {
            dataModelDisplayedError = nil
            try delegate?.updated(dataModel: dataModel)
        } catch let error {
            dataModelDisplayedError = error
        }

        if (cartCheckout?.checkout == nil || addressesChanged) && hasAddresses {
            createCartCheckout { [weak self] result in
                guard let cartCheckout = result.process() else { return }
                self?.cartCheckout = cartCheckout
            }
        }
    }

    private func addressesChanged(withNewAddresses addresses: CheckoutAddresses?) -> Bool {
        return !(addresses?.shippingAddress === shippingAddress && addresses?.billingAddress === billingAddress)
    }

}

// MARK: – Address Modifications
extension LoggedInSummaryActionHandler {

    fileprivate func updated(address: EquatableAddress) {
        if let shippingAddress = shippingAddress, shippingAddress == address,
            let billingAddress = billingAddress, billingAddress == address {
            update(billingAddress: address, shippingAddress: address)
        } else if let shippingAddress = shippingAddress, shippingAddress == address {
            update(shippingAddress: address)
        } else if let billingAddress = billingAddress, billingAddress == address {
            update(billingAddress: address)
        }
    }

    fileprivate func deleted(address deletedAddress: EquatableAddress) {
        if let shippingAddress = shippingAddress, shippingAddress == deletedAddress {
            delete(shippingAddress: true)
        }
        if let billingAddress = billingAddress, billingAddress == deletedAddress {
            delete(billingAddress: true)
        }
    }

    fileprivate func select(shippingAddress newShippingAddress: ShippingAddress?) {
        update(shippingAddress: newShippingAddress)
    }

    fileprivate func select(billingAddress newBillingAddress: BillingAddress?) {
        update(billingAddress: newBillingAddress)
    }

}
