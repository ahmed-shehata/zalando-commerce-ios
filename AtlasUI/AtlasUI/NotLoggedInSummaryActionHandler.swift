//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class NotLoggedInSummaryActionHandler: CheckoutSummaryActionHandler {

    weak var dataSource: CheckoutSummaryActionHandlerDataSource?
    weak var delegate: CheckoutSummaryActionHandlerDelegate?
    private let guestAddressActionHandler = GuestAddressActionHandler()

    func handleSubmitButton() {
        guard let dataSource = dataSource, let delegate = delegate else { return }

        AtlasUIClient.customer { result in
            guard let customer = result.process() else { return }

            let selectedArticleUnit = dataSource.dataModel.selectedArticleUnit
            LoggedInSummaryActionHandler.createInstance(customer, selectedUnit: selectedArticleUnit) { result in
                guard let actionHandler = result.process() else { return }

                let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit, cartCheckout: actionHandler.cartCheckout)
                delegate.actionHandlerUpdated(actionHandler)
                delegate.dataModelUpdated(dataModel)
                delegate.layoutUpdated(LoggedInLayout())
            }
        }
    }

    func showPaymentSelectionScreen() {
        UserMessage.displayError(AtlasCheckoutError.missingAddress)
    }

    func showShippingAddressSelectionScreen() {
        guestAddressActionHandler.addressCreationStrategy = ShippingAddressViewModelCreationStrategy()
        guestAddressActionHandler.createAddress { [weak self] address in
            let checkoutAddress = self?.guestAddressActionHandler.checkoutAddresses(address, billingAddress: nil)
            self?.switchToGuestCheckout(checkoutAddress)
        }
    }

    func showBillingAddressSelectionScreen() {
        guestAddressActionHandler.addressCreationStrategy = BillingAddressViewModelCreationStrategy()
        guestAddressActionHandler.createAddress { [weak self] address in
            let checkoutAddress = self?.guestAddressActionHandler.checkoutAddresses(nil, billingAddress: address)
            self?.switchToGuestCheckout(checkoutAddress)
        }
    }

}

extension NotLoggedInSummaryActionHandler {

    private func switchToGuestCheckout(checkoutAddress: CheckoutAddresses?) {
        guard let
            selectedArticleUnit = dataSource?.dataModel.selectedArticleUnit,
            let email = guestAddressActionHandler.emailAddress else { return }

        let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit,
                                                 shippingAddress: checkoutAddress?.shippingAddress,
                                                 billingAddress: checkoutAddress?.billingAddress,
                                                 totalPrice: selectedArticleUnit.priceAmount,
                                                 email: email)
        let actionHandler = GuestCheckoutSummaryActionHandler(email: email)
        delegate?.actionHandlerUpdated(actionHandler)
        delegate?.dataModelUpdated(dataModel)
        delegate?.layoutUpdated(GuestCheckoutLayout())
    }

}
