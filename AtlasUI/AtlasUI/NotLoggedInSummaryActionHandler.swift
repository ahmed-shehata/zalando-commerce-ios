//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct NotLoggedInSummaryActionHandler: CheckoutSummaryActionHandler {

    weak var dataSource: CheckoutSummaryActionHandlerDataSource?
    weak var delegate: CheckoutSummaryActionHandlerDelegate?

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
        let addressViewController = AddressPickerViewController(initialAddresses: [], selectedAddress: nil)
        addressViewController.addressSelectedHandler = { self.selectShippingAddress($0) }
        addressViewController.addressCreationStrategy = ShippingAddressCreationStrategy()
        addressViewController.title = Localizer.string("addressListView.title.shipping")
        AtlasUIViewController.instance?.mainNavigationController.pushViewController(addressViewController, animated: true)
    }

    func showBillingAddressSelectionScreen() {
        let addressViewController = AddressPickerViewController(initialAddresses: [], selectedAddress: nil)
        addressViewController.addressSelectedHandler = { self.selectShippingAddress($0) }
        addressViewController.addressCreationStrategy = BillingAddressCreationStrategy()
        addressViewController.title = Localizer.string("addressListView.title.billing")
        AtlasUIViewController.instance?.mainNavigationController.pushViewController(addressViewController, animated: true)
    }

}

extension NotLoggedInActionHandler {

    private func selectShippingAddress(address: EquatableAddress) {
        // TODO: need to get the email
        switchToGuestCheckout(withEmail: "", shippingAddress: address, billingAddress: nil)
    }

    private func selectBillingAddress(address: EquatableAddress) {
        // TODO: need to get the email
        switchToGuestCheckout(withEmail: "", shippingAddress: nil, billingAddress: address)
    }

    private func switchToGuestCheckout(withEmail email: String, shippingAddress: EquatableAddress?, billingAddress: EquatableAddress?) {
        guard let dataSource = dataSource, address = shippingAddress ?? billingAddress else { return }

        let selectedArticleUnit = dataSource.dataModel.selectedArticleUnit
        let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit,
                                                 shippingAddress: shippingAddress,
                                                 billingAddress: billingAddress)
        let actionHandler = GuestCheckoutActionHandler(email: email, address: address)
        delegate?.actionHandlerUpdated(actionHandler)
        delegate?.dataModelUpdated(dataModel)
        delegate?.layoutUpdated(GuestCheckoutLayout())
    }

}
