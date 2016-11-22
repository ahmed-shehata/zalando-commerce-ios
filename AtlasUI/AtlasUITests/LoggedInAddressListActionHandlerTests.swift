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

    override func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer()
    }

    override func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer()
    }

    func testCreateAddress() {
        guard registerAtlasUIViewController() != nil else { return fail() }
        let strategyMock = AddressViewModelCreationStrategyMock()
        let actionHandler = LoggedInAddressListActionHandler(addressViewModelCreationStrategy: strategyMock)
        actionHandler.delegate = delegate
        actionHandler.createAddress()
//        print(atlasUIViewController.presentedViewController)
//        expect(atlasUIViewController.presentedViewController as? AddressFormViewController).toNotEventually(beNil())
//        expect(self.delegate.addresses.count).toEventually(equal(1))
//        print(atlasUIViewController.presentedViewController)

    }
    
}

extension LoggedInAddressListActionHandlerTests {

    fileprivate func registerAtlasUIViewController() -> AtlasUIViewController? {
        var atlasUIViewController: AtlasUIViewController?
        waitUntil(timeout: 10) { done in
            let options = Options(clientId: "CLIENT_ID",
                                  salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                                  interfaceLanguage: "en",
                                  configurationURL: AtlasMockAPI.endpointURL(forPath: "/config"))

            AtlasUI.configure(options: options) { _ in
                atlasUIViewController = AtlasUIViewController(forSKU: "AD541L009-G11")
                UIApplication.shared.windows.first?.rootViewController = atlasUIViewController
                guard let viewController = atlasUIViewController else { return fail() }
                let _  = viewController.view // load the view
                AtlasUI.register { viewController }
                done()
            }
        }
        return atlasUIViewController
    }

}

class AddressViewModelCreationStrategyMock: AddressViewModelCreationStrategy {

    var strategyCompletion: AddressViewModelCreationStrategyCompletion?

    func execute() {
        let dataModel = AddressFormDataModel(equatableAddress: nil, countryCode: nil)
        let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .standardAddress)
        strategyCompletion?(viewModel)
    }

}
