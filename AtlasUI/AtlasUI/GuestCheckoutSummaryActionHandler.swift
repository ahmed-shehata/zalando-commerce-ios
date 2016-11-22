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
    var guestCheckout: GuestCheckout? {
        didSet {
            updateDataModel(addresses, guestCheckout: guestCheckout)
        }
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
        let creationStrategy = ShippingAddressViewModelCreationStrategy()
        let addressViewController = AddressListViewController(initialAddresses: addresses, selectedAddress: shippingAddress)
        addressViewController.addressUpdatedHandler = { self.addressUpdated($0) }
        addressViewController.addressDeletedHandler = { self.addressDeleted($0) }
        addressViewController.addressSelectedHandler = { self.selectShippingAddress($0) }
        addressViewController.actionHandler = GuestCheckoutAddressListActionHandler(addressViewModelCreationStrategy: creationStrategy)
        addressViewController.title = Localizer.string("addressListView.title.shipping")
        AtlasUIViewController.instance?.mainNavigationController.pushViewController(addressViewController, animated: true)
    }

    func showBillingAddressSelectionScreen() {
        let creationStrategy = BillingAddressViewModelCreationStrategy()
        let addressViewController = AddressListViewController(initialAddresses: addresses, selectedAddress: billingAddress)
        addressViewController.addressUpdatedHandler = { self.addressUpdated($0) }
        addressViewController.addressDeletedHandler = { self.addressDeleted($0) }
        addressViewController.addressSelectedHandler = { self.selectBillingAddress($0) }
        addressViewController.actionHandler = GuestCheckoutAddressListActionHandler(addressViewModelCreationStrategy: creationStrategy)
        addressViewController.title = Localizer.string("addressListView.title.billing")
        AtlasUIViewController.instance?.mainNavigationController.pushViewController(addressViewController, animated: true)
    }

}

extension GuestCheckoutSummaryActionHandler {

    private func updateDataModel(addresses: CheckoutAddresses?, guestCheckout: GuestCheckout?) {
        guard let selectedUnit = dataSource?.dataModel.selectedArticleUnit else { return }
        let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedUnit, guestCheckout: guestCheckout, addresses: addresses)
        delegate?.dataModelUpdated(dataModel)
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
            updateDataModel(CheckoutAddresses(billingAddress: billingAddress, shippingAddress: nil), guestCheckout: nil)
            guestCheckout = nil
        }
        if let billingAddress = billingAddress where billingAddress == address {
            updateDataModel(CheckoutAddresses(billingAddress: nil, shippingAddress: shippingAddress), guestCheckout: nil)
            guestCheckout = nil
        }
    }

    private func selectShippingAddress(address: EquatableAddress) {
        updateDataModel(CheckoutAddresses(billingAddress: billingAddress, shippingAddress: address), guestCheckout: guestCheckout)
    }

    private func selectBillingAddress(address: EquatableAddress) {
        updateDataModel(CheckoutAddresses(billingAddress: address, shippingAddress: shippingAddress), guestCheckout: guestCheckout)
    }

}
