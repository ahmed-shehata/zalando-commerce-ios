//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import ZalandoCommerceUI
@testable import ZalandoCommerceAPI

class LoggedInAddressListActionHandlerTests: UITestCase {

    let delegate = AddressListTableDelegate(tableView: UITableView(), addresses: [], selectedAddress: nil, viewController: nil)
    var actionHandler: LoggedInAddressListActionHandler?

    override func setUp() {
        super.setUp()
        actionHandler = createActionHandler()
    }

    func testCreateAddress() {
        actionHandler?.createAddress()

        guard let saveButton = getSaveButton() else { return fail() }
        UIApplication.shared.sendAction(saveButton.action!, to: saveButton.target, from: nil, for: nil)

        expect(self.delegate.addresses.count).toEventually(equal(1))
    }

    func testUpdateAddress() {
        let userAddress = UserAddress(addressId: "6616154")
        delegate.addresses.append(userAddress)
        expect(self.delegate.addresses.first?.lastName) == "Doe"

        actionHandler?.update(address: userAddress)

        guard let saveButton = getSaveButton() else { return fail() }
        UIApplication.shared.sendAction(saveButton.action!, to: saveButton.target, from: nil, for: nil)

        expect(self.delegate.addresses.first?.lastName).toEventually(equal("Doe Edited"))
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

    fileprivate func createActionHandler() -> LoggedInAddressListActionHandler? {
        let strategyMock = AddressViewModelCreationStrategyMock()
        let actionHandler = LoggedInAddressListActionHandler(addressViewModelCreationStrategy: strategyMock)
        actionHandler.delegate = delegate
        return actionHandler
    }

    fileprivate func getSaveButton() -> UIBarButtonItem? {
        guard let zCommerceUIViewController = self.zCommerceUIViewController else {
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
        if zCommerceUIViewController.mainNavigationController.viewControllers.count > 1 {
            expect(zCommerceUIViewController.mainNavigationController.viewControllers.last as? AddressFormViewController).toNotEventually(beNil())
            addressFormViewController = zCommerceUIViewController.mainNavigationController.viewControllers.last as? AddressFormViewController
        } else {
            expect(zCommerceUIViewController.presentedViewController as? UINavigationController).toNotEventually(beNil())
            guard let viewController = (zCommerceUIViewController.presentedViewController as? UINavigationController)?.viewControllers.first as? AddressFormViewController else {
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
