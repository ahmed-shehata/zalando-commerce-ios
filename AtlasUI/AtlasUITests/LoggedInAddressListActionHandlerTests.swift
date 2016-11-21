//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble
import AtlasMockAPI

@testable import AtlasUI
@testable import AtlasSDK

class LoggedInAddressListActionHandlerTests: XCTestCase {

    let delegate = AddressListTableDelegate(tableView: UITableView(), addresses: [], selectedAddress: nil, viewController: nil)
    let window = UIWindow()

    override class func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer()
    }

    override class func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer()
    }

    func testCreateAddress() {
        guard let actionHandler = createActionHandler() else { return fail() }
        actionHandler.createAddress()

        guard let saveButton = getSaveButton() else { return fail() }
        UIApplication.sharedApplication().sendAction(saveButton.action, to: saveButton.target, from: nil, forEvent: nil)

        expect(self.delegate.addresses.count).toEventually(equal(1), timeout: 10)
    }

    func testUpdateAddress() {
        guard let actionHandler = createActionHandler() else { return fail() }

        let userAddress = UserAddress(addressId: "6616154")
        delegate.addresses.append(userAddress)
        expect(self.delegate.addresses.first?.lastName).to(equal("Doe"))

        actionHandler.updateAddress(userAddress)

        guard let saveButton = getSaveButton() else { return fail() }
        UIApplication.sharedApplication().sendAction(saveButton.action, to: saveButton.target, from: nil, forEvent: nil)

        expect(self.delegate.addresses.first?.lastName).toEventually(equal("Doe Edited"), timeout: 10)
    }

    func testDeleteAddress() {
        guard let actionHandler = createActionHandler() else { return fail() }

        let userAddress = UserAddress(addressId: "6616154")
        delegate.addresses.append(userAddress)
        expect(self.delegate.addresses.count).to(equal(1))

        actionHandler.deleteAddress(userAddress)

        expect(self.delegate.addresses).toEventually(beEmpty())
    }

}

extension LoggedInAddressListActionHandlerTests {

    private func registerAtlasUIViewController() -> AtlasUIViewController? {
        var atlasUIViewController: AtlasUIViewController?
        waitUntil(timeout: 10) { done in
            let options = Options(clientId: "CLIENT_ID",
                                  salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                                  interfaceLanguage: "en",
                                  configurationURL: AtlasMockAPI.endpointURL(forPath: "/config"))

            AtlasUI.configure(options) { _ in
                atlasUIViewController = AtlasUIViewController(forProductSKU: "AD541L009-G11")
                guard let viewController = atlasUIViewController else { return fail() }
                self.window.rootViewController = viewController
                self.window.makeKeyAndVisible()
                AtlasUI.register { viewController }
                done()
            }
        }
        return atlasUIViewController
    }

    private func createActionHandler() -> LoggedInAddressListActionHandler? {
        guard registerAtlasUIViewController() != nil else {
            fail()
            return nil
        }

        let strategyMock = AddressViewModelCreationStrategyMock()
        var actionHandler = LoggedInAddressListActionHandler(addressViewModelCreationStrategy: strategyMock)
        actionHandler.delegate = delegate
        return actionHandler
    }

    private func getSaveButton() -> UIBarButtonItem? {
        guard let atlasUIViewController = AtlasUIViewController.instance else {
            fail()
            return nil
        }

        var addressFormViewController: AddressFormViewController?
        if atlasUIViewController.mainNavigationController.viewControllers.count > 1 {
            expect(atlasUIViewController.mainNavigationController.viewControllers.last as? AddressFormViewController).toNotEventually(beNil())
            addressFormViewController = atlasUIViewController.mainNavigationController.viewControllers.last as? AddressFormViewController
        } else {
            expect(atlasUIViewController.presentedViewController as? UINavigationController).toNotEventually(beNil())
            guard let viewController = (atlasUIViewController.presentedViewController as? UINavigationController)?.viewControllers.first as? AddressFormViewController else {
                fail()
                return nil
            }
            addressFormViewController = viewController
        }

        expect(addressFormViewController?.navigationItem.rightBarButtonItem).toNotEventually(beNil())
        guard let saveButton = addressFormViewController?.navigationItem.rightBarButtonItem else {
            fail()
            return nil
        }

        return saveButton
    }

}

class AddressViewModelCreationStrategyMock: AddressViewModelCreationStrategy {

    var completion: AddressViewModelCreationStrategyCompletion?

    func setStrategyCompletion(completion: AddressViewModelCreationStrategyCompletion?) {
        self.completion = completion
    }

    func execute() {
        let dataModel = AddressFormDataModel(equatableAddress: UserAddress(addressId: "6616154"), countryCode: "DE")
        let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .standardAddress)
        completion?(addressViewModel: viewModel)
    }

}

private extension UserAddress {

    init(addressId: String) {
        id = addressId
        customerNumber = "123"
        gender = .male
        firstName = "John"
        lastName = "Doe"
        street = "Mollstr. 1"
        additional = "C/O Zalando SE"
        zip = "10178"
        city = "Berlin"
        countryCode = "DE"
        pickupPoint = nil
        isDefaultBilling = false
        isDefaultShipping = false
    }

}
