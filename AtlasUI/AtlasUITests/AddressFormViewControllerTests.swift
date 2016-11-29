//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble
import AtlasMockAPI

@testable import AtlasUI
@testable import AtlasSDK

class AddressFormViewControllerTests: XCTestCase {

    let window = UIWindow()

    override class func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer()
    }

    override class func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer()
    }

    func testLoggedInCreateAddressActionHandler() {
        guard registerAtlasUIViewController() != nil else { return fail() }

        var actionHandler = LoggedInCreateAddressActionHandler()
        let dataModel = createAddressFormDataModel()
        let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .standardAddress)
        let addressFormViewController = AddressFormViewController(viewModel: viewModel, actionHandler: actionHandler, completion: nil)
        actionHandler.delegate = addressFormViewController
        addressFormViewController.displayView()
        expect(addressFormViewController.navigationItem.rightBarButtonItem).toNotEventually(beNil())
        guard let barButtonItem = addressFormViewController.navigationItem.rightBarButtonItem else { return fail() }

        waitUntil(timeout: 10) { done in
            addressFormViewController.completion = { address in
                expect(address.address.id).to(equal("6948960"))
                expect(address.address.gender).to(equal(Gender.male))
                expect(address.address.firstName).to(equal("John"))
                expect(address.address.lastName).to(equal("Doe"))
                expect(address.address.street).to(equal("Mollstr. 1"))
                expect(address.address.additional).to(beNil())
                expect(address.address.zip).to(equal("10178"))
                expect(address.address.city).to(equal("Berlin"))
                done()
            }
            UIApplication.sharedApplication().sendAction(barButtonItem.action, to: barButtonItem.target, from: nil, forEvent: nil)
        }
    }

    func testLoggedInUpdateAddressActionHandler() {
        guard registerAtlasUIViewController() != nil else { return fail() }

        var actionHandler = LoggedInUpdateAddressActionHandler()
        let dataModel = createAddressFormDataModel()
        let viewModel = AddressFormViewModel(dataModel: dataModel, layout: UpdateAddressFormLayout(), type: .standardAddress)
        let addressFormViewController = AddressFormViewController(viewModel: viewModel, actionHandler: actionHandler, completion: nil)
        actionHandler.delegate = addressFormViewController
        addressFormViewController.displayView()
        expect(addressFormViewController.navigationItem.rightBarButtonItem).toNotEventually(beNil())
        guard let saveButton = addressFormViewController.navigationItem.rightBarButtonItem else { return fail() }

        waitUntil(timeout: 10) { done in
            addressFormViewController.completion = { address in
                expect(address.address.id).to(equal("6616154"))
                expect(address.address.gender).to(equal(Gender.male))
                expect(address.address.firstName).to(equal("John"))
                expect(address.address.lastName).to(equal("Doe Edited"))
                expect(address.address.street).to(equal("Mollstr. 1"))
                expect(address.address.additional).to(equal("EG"))
                expect(address.address.zip).to(equal("10178"))
                expect(address.address.city).to(equal("Berlin"))
                done()
            }
            UIApplication.sharedApplication().sendAction(saveButton.action, to: saveButton.target, from: nil, forEvent: nil)
        }
    }

}

extension AddressFormViewControllerTests {

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

    private func createAddressFormDataModel() -> AddressFormDataModel {
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
