//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class GuestCheckoutSummaryActionHandler: CheckoutSummaryActionHandler {

    weak var dataSource: CheckoutSummaryActionHandlerDataSource?
    weak var delegate: CheckoutSummaryActionHandlerDelegate?

    private var email: String
    private var addresses: [EquatableAddress]

    private var shippingAddress: EquatableAddress? {
        return dataSource?.dataModel.shippingAddress as? EquatableAddress
    }
    private var billingAddress: EquatableAddress? {
        return dataSource?.dataModel.billingAddress as? EquatableAddress
    }

    init(email: String, address: EquatableAddress) {
        self.email = email
        self.addresses = [address]
    }

    func handleSubmitButton() {

    }

    func showPaymentSelectionScreen() {

    }

    func showShippingAddressSelectionScreen() {
//        let addressViewController = AddressPickerViewController(initialAddresses: addresses, selectedAddress: shippingAddress)
//        addressViewController.addressUpdatedHandler = { self.addressUpdated($0) }
//        addressViewController.addressDeletedHandler = { self.addressDeleted($0) }
//        addressViewController.addressSelectedHandler = { self.selectShippingAddress($0) }
//        addressViewController.addressCreationStrategy = ShippingAddressCreationStrategy()
//        addressViewController.title = Localizer.string("addressListView.title.shipping")
//        AtlasUIViewController.instance?.mainNavigationController.pushViewController(addressViewController, animated: true)
    }

    func showBillingAddressSelectionScreen() {
//        let addresses = self.addresses.filter { $0.pickupPoint == nil } .map { $0 }
//        let addressViewController = AddressPickerViewController(initialAddresses: addresses, selectedAddress: billingAddress)
//        addressViewController.addressUpdatedHandler = { self.addressUpdated($0) }
//        addressViewController.addressDeletedHandler = { self.addressDeleted($0) }
//        addressViewController.addressSelectedHandler = { self.selectBillingAddress($0) }
//        addressViewController.addressCreationStrategy = BillingAddressCreationStrategy()
//        addressViewController.title = Localizer.string("addressListView.title.billing")
//        AtlasUIViewController.instance?.mainNavigationController.pushViewController(addressViewController, animated: true)
    }

}

extension GuestCheckoutSummaryActionHandler {

    private func addressUpdated(address: EquatableAddress) {
        if let shippingAddress = shippingAddress where shippingAddress == address {
            selectShippingAddress(address)
        }
        if let billingAddress = billingAddress where billingAddress == address {
            selectBillingAddress(address)
        }
    }

    private func addressDeleted(address: EquatableAddress) {
        if let shippingAddress = shippingAddress where shippingAddress == address {
//            updateDataModelWithNoCartCheckout(CheckoutAddresses(billingAddress: billingAddress, shippingAddress: nil))
//            cartCheckout?.checkout = nil
        }
        if let billingAddress = billingAddress where billingAddress == address {
//            updateDataModelWithNoCartCheckout(CheckoutAddresses(billingAddress: nil, shippingAddress: shippingAddress))
//            cartCheckout?.checkout = nil
        }
    }

    private func selectShippingAddress(address: EquatableAddress) {
//        updateDataModel(CheckoutAddresses(billingAddress: billingAddress, shippingAddress: address))
    }

    private func selectBillingAddress(address: EquatableAddress) {
//        updateDataModel(CheckoutAddresses(billingAddress: address, shippingAddress: shippingAddress))
    }
    
}
