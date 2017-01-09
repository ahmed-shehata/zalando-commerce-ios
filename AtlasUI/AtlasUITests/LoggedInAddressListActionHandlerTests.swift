//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasUI
@testable import AtlasSDK

class LoggedInAddressListActionHandlerTests: UITestCase {

    let delegate = AddressListTableDelegate(tableView: UITableView(), addresses: [], selectedAddress: nil, viewController: nil)
    let window = UIWindow()
    var actionHandler: LoggedInAddressListActionHandler?

    override func setUp() {
        super.setUp()
        registerAtlasUIViewController()
        actionHandler = createActionHandler()
    }

    func testCreateAddress() {
        actionHandler?.createAddress()

        guard let saveButton = getSaveButton() else { return fail() }
        UIApplication.shared.sendAction(saveButton.action!, to: saveButton.target, from: nil, for: nil)

        expect(self.delegate.addresses.count).toEventually(equal(1), timeout: 10)
    }

    func testUpdateAddress() {
        let userAddress = UserAddress(addressId: "6616154")
        delegate.addresses.append(userAddress)
        expect(self.delegate.addresses.first?.lastName) == "Doe"

        actionHandler?.update(address: userAddress)

        guard let saveButton = getSaveButton() else { return fail() }
        UIApplication.shared.sendAction(saveButton.action!, to: saveButton.target, from: nil, for: nil)

        expect(self.delegate.addresses.first?.lastName).toEventually(equal("Doe Edited"), timeout: 10)
    }

    func testDeleteAddress() {
        let userAddress = UserAddress(addressId: "6616154")
        delegate.addresses.append(userAddress)
        expect(self.delegate.addresses.count) == 1

        actionHandler?.delete(address: userAddress)

        expect(self.delegate.addresses).toEventually(beEmpty())
    }

}

extension LoggedInAddressListActionHandlerTests {

    fileprivate func registerAtlasUIViewController() {
        let atlasUIViewController = AtlasUIViewController(forSKU: "AD541L009-G11")
        self.window.rootViewController = atlasUIViewController
        self.window.makeKeyAndVisible()
        try! AtlasUI.shared().register { atlasUIViewController }
    }

    fileprivate func createActionHandler() -> LoggedInAddressListActionHandler? {
        let strategyMock = AddressViewModelCreationStrategyMock()
        let actionHandler = LoggedInAddressListActionHandler(addressViewModelCreationStrategy: strategyMock)
        actionHandler.delegate = delegate
        return actionHandler
    }

    fileprivate func getSaveButton() -> UIBarButtonItem? {
        guard let atlasUIViewController = AtlasUIViewController.shared else {
            fail()
            return nil
        }

        // Delay until the viewController is pushed into the navigation controller
        waitUntil(timeout: 10) { done in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                done()
            }
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

    var titleKey: String?
    var strategyCompletion: AddressViewModelCreationStrategyCompletion?

    func execute() {
        let dataModel = AddressFormDataModel(equatableAddress: UserAddress(addressId: "6616154"), countryCode: "DE")
        let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .standardAddress)
        strategyCompletion?(viewModel)
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
