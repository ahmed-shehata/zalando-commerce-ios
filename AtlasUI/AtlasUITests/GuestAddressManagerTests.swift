//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasUI
@testable import AtlasSDK

class GuestAddressActionHandlerTests: UITestCase {

    var guestAddressActionHandler = GuestAddressActionHandler()

    func testCreateShippingAddress() {
        guestAddressActionHandler.addressCreationStrategy = ShippingAddressViewModelCreationStrategy()
        guestAddressActionHandler.createAddress { _ in }
        expect(UIApplication.topViewController() as? UIAlertController).toNotEventually(beNil())
        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
    }

    func testCreateBilingAddress() {
        guestAddressActionHandler.addressCreationStrategy = BillingAddressViewModelCreationStrategy()
        guestAddressActionHandler.createAddress { _ in }
        expect(UIApplication.topViewController() as? UIAlertController).toNotEventually(beNil())
        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
    }

    func testUpdateShippingAddress() {
        guestAddressActionHandler.addressCreationStrategy = ShippingAddressViewModelCreationStrategy()
        guestAddressActionHandler.updateAddress(address: createStandardAddress()) { _ in }
        expect(self.defaultNavigationController?.viewControllers.last as? AddressFormViewController).toNotEventually(beNil())
    }

    func testUpdateBilingAddress() {
        guestAddressActionHandler.addressCreationStrategy = BillingAddressViewModelCreationStrategy()
        guestAddressActionHandler.updateAddress(address: createStandardAddress()) { _ in }
        expect(self.defaultNavigationController?.viewControllers.last as? AddressFormViewController).toNotEventually(beNil())
    }

    func testModifyShippingAddress() {
        guestAddressActionHandler.addressCreationStrategy = ShippingAddressViewModelCreationStrategy()
        guestAddressActionHandler.handleAddressModification(address: createStandardAddress()) { _ in }
        expect(UIApplication.topViewController() as? UIAlertController).toNotEventually(beNil())
        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
    }

    func testModifyNoAddress() {
        guestAddressActionHandler.addressCreationStrategy = ShippingAddressViewModelCreationStrategy()
        guestAddressActionHandler.handleAddressModification(address: nil) { _ in }
        expect(UIApplication.topViewController() as? UIAlertController).toNotEventually(beNil())
        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
    }

    func testCheckoutAddressesWithStandardShippingAddress() {
        let checkoutAddresses = CheckoutAddresses(shippingAddress: createStandardAddress(), billingAddress: nil, autoFill: true)
        expect(checkoutAddresses.billingAddress).toNot(beNil())
    }

    func testCheckoutAddressesWithPickupPointShippingAddress() {
        let checkoutAddresses = CheckoutAddresses(shippingAddress: createPickupPointAddress(), billingAddress: nil, autoFill: true)
        expect(checkoutAddresses.billingAddress).to(beNil())
    }

}

extension GuestAddressActionHandlerTests {

    fileprivate func createStandardAddress() -> GuestCheckoutAddress {
        return GuestCheckoutAddress(id: "",
                                    gender: .male,
                                    firstName: "John",
                                    lastName: "Doe",
                                    street: "Mollstr. 1",
                                    additional: nil,
                                    zip: "10178",
                                    city: "Berlin",
                                    countryCode: "DE",
                                    pickupPoint: nil)
    }

    fileprivate func createPickupPointAddress() -> GuestCheckoutAddress {
        return GuestCheckoutAddress(id: "",
                                    gender: .male,
                                    firstName: "John",
                                    lastName: "Doe",
                                    street: nil,
                                    additional: nil,
                                    zip: "10178",
                                    city: "Berlin",
                                    countryCode: "DE",
                                    pickupPoint: PickupPoint(id: "1", name: "PickupPoiny", memberId: "1"))
    }

}
