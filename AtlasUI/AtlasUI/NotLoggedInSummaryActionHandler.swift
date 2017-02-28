//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class NotLoggedInSummaryActionHandler: CheckoutSummaryActionHandler {

    weak var dataSource: CheckoutSummaryActionHandlerDataSource?
    weak var delegate: CheckoutSummaryActionHandlerDelegate?
    fileprivate let guestAddressActionHandler = GuestAddressActionHandler()

    func handleSubmit() {
        guard let dataSource = dataSource, let delegate = delegate else { return }

        AtlasAPI.withLoader.customer { result in
            guard let customer = result.process() else { return }

            let selectedArticle = dataSource.dataModel.selectedArticle
            LoggedInSummaryActionHandler.create(customer: customer, selectedArticle: selectedArticle) { result in
                guard let actionHandler = result.process() else { return }

                let dataModel = CheckoutSummaryDataModel(selectedArticle: selectedArticle, cartCheckout: actionHandler.cartCheckout)
                try? delegate.updated(dataModel: dataModel)
                delegate.updated(layout: LoggedInLayout())
                delegate.updated(actionHandler: actionHandler)
            }
        }
    }

    func handlePaymentSelection() {
        guard isGuestCheckoutEnabled else { return handleSubmit() }
        UserError.display(error: CheckoutError.missingAddress)
    }

    func handleShippingAddressSelection() {
        guard isGuestCheckoutEnabled else { return handleSubmit() }
        guestAddressActionHandler.addressCreationStrategy = ShippingAddressViewModelCreationStrategy()
        guestAddressActionHandler.createAddress { [weak self] newAddress in
            let checkoutAddress = CheckoutAddresses(shippingAddress: newAddress, billingAddress: nil, autoFill: true)
            self?.switchToGuestCheckout(checkoutAddress: checkoutAddress)
        }
    }

    func handleBillingAddressSelection() {
        guard isGuestCheckoutEnabled else { return handleSubmit() }
        guestAddressActionHandler.addressCreationStrategy = BillingAddressViewModelCreationStrategy()
        guestAddressActionHandler.createAddress { [weak self] newAddress in
            let checkoutAddress = CheckoutAddresses(shippingAddress: nil, billingAddress: newAddress, autoFill: true)
            self?.switchToGuestCheckout(checkoutAddress: checkoutAddress)
        }
    }

    func updated(selectedArticle: SelectedArticle) {
        let dataModel = CheckoutSummaryDataModel(selectedArticle: selectedArticle, totalPrice: selectedArticle.totalPrice)
        try? delegate?.updated(dataModel: dataModel)
    }

}

extension NotLoggedInSummaryActionHandler {

    fileprivate func switchToGuestCheckout(checkoutAddress: CheckoutAddresses?) {
        guard let
            selectedArticle = dataSource?.dataModel.selectedArticle,
            let email = guestAddressActionHandler.emailAddress else { return }

        let dataModel = CheckoutSummaryDataModel(selectedArticle: selectedArticle,
                                                 shippingAddress: checkoutAddress?.shippingAddress,
                                                 billingAddress: checkoutAddress?.billingAddress,
                                                 totalPrice: selectedArticle.totalPrice,
                                                 email: email)
        let actionHandler = GuestCheckoutSummaryActionHandler(email: email)
        try? delegate?.updated(dataModel: dataModel)
        delegate?.updated(layout: GuestCheckoutLayout())
        delegate?.updated(actionHandler: actionHandler)
    }

    fileprivate var isGuestCheckoutEnabled: Bool {
        return Config.shared?.guestCheckoutEnabled ?? false
    }

}
