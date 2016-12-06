//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasUI
@testable import AtlasSDK

class AddressFormViewControllerTests: UITestCase {

    let window = UIWindow()

    override func setUp() {
        super.setUp()
        registerAtlasUIViewController()
    }

    func testLoggedInCreateAddressActionHandler() {
        var actionHandler = LoggedInCreateAddressActionHandler()
        let dataModel = createAddressFormDataModel()
        let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .standardAddress)
        let addressFormViewController = AddressFormViewController(viewModel: viewModel, actionHandler: actionHandler, completion: nil)
        actionHandler.delegate = addressFormViewController
        addressFormViewController.present()
        expect(addressFormViewController.navigationItem.rightBarButtonItem).toNotEventually(beNil())
        guard let barButtonItem = addressFormViewController.navigationItem.rightBarButtonItem else { return fail() }

        waitUntil(timeout: 10) { done in
            addressFormViewController.completion = { address, _ in
                expect(address.id).to(equal("6948960"))
                expect(address.gender).to(equal(Gender.male))
                expect(address.firstName).to(equal("John"))
                expect(address.lastName).to(equal("Doe"))
                expect(address.street).to(equal("Mollstr. 1"))
                expect(address.additional).to(beNil())
                expect(address.zip).to(equal("10178"))
                expect(address.city).to(equal("Berlin"))
                done()
            }
            _ = UIApplication.shared.sendAction(barButtonItem.action!, to: barButtonItem.target, from: nil, for: nil)
        }
    }

    func testLoggedInUpdateAddressActionHandler() {
        var actionHandler = LoggedInUpdateAddressActionHandler()
        let dataModel = createAddressFormDataModel()
        let viewModel = AddressFormViewModel(dataModel: dataModel, layout: UpdateAddressFormLayout(), type: .standardAddress)
        let addressFormViewController = AddressFormViewController(viewModel: viewModel, actionHandler: actionHandler, completion: nil)
        actionHandler.delegate = addressFormViewController
        addressFormViewController.present()
        expect(addressFormViewController.navigationItem.rightBarButtonItem).toNotEventually(beNil())
        guard let saveButton = addressFormViewController.navigationItem.rightBarButtonItem else { return fail() }

        waitUntil(timeout: 10) { done in
            addressFormViewController.completion = { address, _ in
                expect(address.id).to(equal("6616154"))
                expect(address.gender).to(equal(Gender.male))
                expect(address.firstName).to(equal("John"))
                expect(address.lastName).to(equal("Doe Edited"))
                expect(address.street).to(equal("Mollstr. 1"))
                expect(address.additional).to(equal("EG"))
                expect(address.zip).to(equal("10178"))
                expect(address.city).to(equal("Berlin"))
                done()
            }
            _ = UIApplication.shared.sendAction(saveButton.action!, to: saveButton.target, from: nil, for: nil)
        }
    }

}

extension AddressFormViewControllerTests {

    fileprivate func registerAtlasUIViewController() {
        let atlasUIViewController = AtlasUIViewController(forSKU: "AD541L009-G11")
        _ = atlasUIViewController.view // load the view
        self.window.rootViewController = atlasUIViewController
        self.window.makeKeyAndVisible()
        try! AtlasUI.shared().register { atlasUIViewController }
    }

    fileprivate func createAddressFormDataModel() -> AddressFormDataModel {
        let dataModel = AddressFormDataModel(countryCode: "DE")
        dataModel.addressId = "6616154"
        dataModel.gender = .male
        dataModel.firstName = "John"
        dataModel.lastName = "Doe"
        dataModel.street = "Mollstr. 1"
        dataModel.additional = "C/O Zalando SE"
        dataModel.zip = "10178"
        dataModel.city = "Berlin"
        return dataModel
    }

}
