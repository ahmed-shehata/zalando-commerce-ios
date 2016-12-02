//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble
import AtlasMockAPI

@testable import AtlasUI
@testable import AtlasSDK

class GuestAddressManagerTests: XCTestCase {

    var manager: GuestAddressManager = GuestAddressManager()
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
        manager.addressCreationStrategy = ShippingAddressViewModelCreationStrategy()
        manager.createAddress { _ in }
        expect(UIApplication.topViewController() as? UIAlertController).toNotEventually(beNil())
    }

    func testCreateBilingAddress() {
        manager.addressCreationStrategy = BillingAddressViewModelCreationStrategy()
        manager.createAddress { _ in }
        expect(UIApplication.topViewController() as? UIAlertController).toNotEventually(beNil())
    }

    func testUpdateShippingAddress() {
        manager.addressCreationStrategy = ShippingAddressViewModelCreationStrategy()
        manager.updateAddress(createAddress()) { _ in }
        expect(AtlasUIViewController.instance?.mainNavigationController.viewControllers.last as? AddressFormViewController).toNotEventually(beNil())
    }

    func testUpdateBilingAddress() {
        manager.addressCreationStrategy = BillingAddressViewModelCreationStrategy()
        manager.updateAddress(createAddress()) { _ in }
        expect(AtlasUIViewController.instance?.mainNavigationController.viewControllers.last as? AddressFormViewController).toNotEventually(beNil())
    }

    func testModifyShippingAddress() {
        manager.addressCreationStrategy = ShippingAddressViewModelCreationStrategy()
        manager.handleAddressModification(createAddress()) { _ in }
        expect(UIApplication.topViewController() as? UIAlertController).toNotEventually(beNil())
    }

    func testModifyNoAddress() {
        manager.addressCreationStrategy = ShippingAddressViewModelCreationStrategy()
        manager.handleAddressModification(nil) { _ in }
        expect(UIApplication.topViewController() as? UIAlertController).toNotEventually(beNil())
    }

    func testCheckoutAddressesWithNormalShippingAddress() {
        let checkoutAddresses = manager.checkoutAddresses(createAddress(), billingAddress: nil)
        expect(checkoutAddresses.billingAddress).toNot(beNil())
    }

    func testCheckoutAddressesWithPickupPointShippingAddress() {
        let checkoutAddresses = manager.checkoutAddresses(createPickupPointAddress(), billingAddress: nil)
        expect(checkoutAddresses.billingAddress).to(beNil())
    }

}

extension GuestAddressManagerTests {

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
