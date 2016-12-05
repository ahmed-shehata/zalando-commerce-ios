//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble
import AtlasMockAPI

@testable import AtlasUI
@testable import AtlasSDK

class GuestAddressActionHandlerTests: XCTestCase {

    var guestAddressActionHandler = GuestAddressActionHandler()
    let window = UIWindow()

    override func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer()
        registerAtlasUIViewController("AD541L009-G11")
    }

    override func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer()
    }

    func testCreateShippingAddress() {
        guestAddressActionHandler.addressCreationStrategy = ShippingAddressViewModelCreationStrategy()
        guestAddressActionHandler.createAddress { _ in }
        expect(UIApplication.topViewController() as? UIAlertController).toNotEventually(beNil())
    }

    func testCreateBilingAddress() {
        guestAddressActionHandler.addressCreationStrategy = BillingAddressViewModelCreationStrategy()
        guestAddressActionHandler.createAddress { _ in }
        expect(UIApplication.topViewController() as? UIAlertController).toNotEventually(beNil())
    }

    func testUpdateShippingAddress() {
        guestAddressActionHandler.addressCreationStrategy = ShippingAddressViewModelCreationStrategy()
        guestAddressActionHandler.updateAddress(createAddress()) { _ in }
        expect(AtlasUIViewController.instance?.mainNavigationController.viewControllers.last as? AddressFormViewController).toNotEventually(beNil())
    }

    func testUpdateBilingAddress() {
        guestAddressActionHandler.addressCreationStrategy = BillingAddressViewModelCreationStrategy()
        guestAddressActionHandler.updateAddress(createAddress()) { _ in }
        expect(AtlasUIViewController.instance?.mainNavigationController.viewControllers.last as? AddressFormViewController).toNotEventually(beNil())
    }

    func testModifyShippingAddress() {
        guestAddressActionHandler.addressCreationStrategy = ShippingAddressViewModelCreationStrategy()
        guestAddressActionHandler.handleAddressModification(createAddress()) { _ in }
        expect(UIApplication.topViewController() as? UIAlertController).toNotEventually(beNil())
    }

    func testModifyNoAddress() {
        guestAddressActionHandler.addressCreationStrategy = ShippingAddressViewModelCreationStrategy()
        guestAddressActionHandler.handleAddressModification(nil) { _ in }
        expect(UIApplication.topViewController() as? UIAlertController).toNotEventually(beNil())
    }

    func testCheckoutAddressesWithNormalShippingAddress() {
        let checkoutAddresses = guestAddressActionHandler.checkoutAddresses(createAddress(), billingAddress: nil)
        expect(checkoutAddresses.billingAddress).toNot(beNil())
    }

    func testCheckoutAddressesWithPickupPointShippingAddress() {
        let checkoutAddresses = guestAddressActionHandler.checkoutAddresses(createPickupPointAddress(), billingAddress: nil)
        expect(checkoutAddresses.billingAddress).to(beNil())
    }

}

extension GuestAddressActionHandlerTests {

    private func registerAtlasUIViewController(sku: String) {
        waitUntil(timeout: 10) { done in
            let options = Options(clientId: "CLIENT_ID",
                                  salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                                  interfaceLanguage: "en",
                                  configurationURL: AtlasMockAPI.endpointURL(forPath: "/config"))

            AtlasUI.configure(options) { _ in
                let atlasUIViewController = AtlasUIViewController(forProductSKU: sku)
                AtlasUI.register { atlasUIViewController }
                let _  = atlasUIViewController.view // load the view
                self.window.rootViewController = atlasUIViewController
                self.window.makeKeyAndVisible()
                done()
            }
        }
    }

    private func createAddress() -> GuestCheckoutAddress {
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

    private func createPickupPointAddress() -> GuestCheckoutAddress {
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
