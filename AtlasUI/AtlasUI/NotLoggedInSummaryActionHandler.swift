//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class NotLoggedInSummaryActionHandler: CheckoutSummaryActionHandler {

    weak var dataSource: CheckoutSummaryActionHandlerDataSource?
    weak var delegate: CheckoutSummaryActionHandlerDelegate?
    fileprivate let guestAddressActionHandler = GuestAddressActionHandler()

    func handleSubmit() {
        guard let dataSource = dataSource, let delegate = delegate else { return }

        AtlasUIClient.customer { result in
            guard let customer = result.process() else { return }

            let selectedArticleUnit = dataSource.dataModel.selectedArticleUnit
            LoggedInSummaryActionHandler.create(customer: customer, selectedArticleUnit: selectedArticleUnit) { result in
                guard let actionHandler = result.process() else { return }

                let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit, cartCheckout: actionHandler.cartCheckout)
                delegate.updated(actionHandler: actionHandler)
                delegate.updated(dataModel: dataModel)
                delegate.updated(layout: LoggedInLayout())
            }
        }
    }

    func handlePaymentSelection() {
        guard isGuestCheckoutEnabled else { return handleSubmit() }
        UserMessage.displayError(error: AtlasCheckoutError.missingAddress)
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

}

extension NotLoggedInSummaryActionHandler {

    fileprivate func switchToGuestCheckout(checkoutAddress: CheckoutAddresses?) {
        guard let
            selectedArticleUnit = dataSource?.dataModel.selectedArticleUnit,
            let email = guestAddressActionHandler.emailAddress else { return }

        let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit,
                                                 shippingAddress: checkoutAddress?.shippingAddress,
                                                 billingAddress: checkoutAddress?.billingAddress,
                                                 totalPrice: selectedArticleUnit.price,
                                                 email: email)
        let actionHandler = GuestCheckoutSummaryActionHandler(email: email)
        delegate?.updated(actionHandler: actionHandler)
        delegate?.updated(dataModel: dataModel)
        delegate?.updated(layout: GuestCheckoutLayout())
    }

    fileprivate var isGuestCheckoutEnabled: Bool {
        return AtlasAPIClient.shared?.config.guestCheckoutEnabled ?? false
    }

}
