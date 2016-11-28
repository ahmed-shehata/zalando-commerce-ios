//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class NotLoggedInSummaryActionHandler: CheckoutSummaryActionHandler {

    weak var dataSource: CheckoutSummaryActionHandlerDataSource?
    weak var delegate: CheckoutSummaryActionHandlerDelegate?
    private let guestAddressManager = GuestAddressManager()

    func handleSubmitButton() {
        guard let dataSource = dataSource, delegate = delegate else { return }

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
        guestAddressManager.addressCreationStrategy = ShippingAddressViewModelCreationStrategy()
        guestAddressManager.createAddress { [weak self] address in
            let checkoutAddress = self?.guestAddressManager.checkoutAddresses(address, billingAddress: nil)
            self?.switchToGuestCheckout(checkoutAddress)
        }
    }

    func showBillingAddressSelectionScreen() {
        guestAddressManager.addressCreationStrategy = BillingAddressViewModelCreationStrategy()
        guestAddressManager.createAddress { [weak self] address in
            let checkoutAddress = self?.guestAddressManager.checkoutAddresses(nil, billingAddress: address)
            self?.switchToGuestCheckout(checkoutAddress)
        }
    }

}

extension NotLoggedInSummaryActionHandler {

    private func switchToGuestCheckout(checkoutAddress: CheckoutAddresses?) {
        guard let selectedArticleUnit = dataSource?.dataModel.selectedArticleUnit, email = guestAddressManager.emailAddress else { return }

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
