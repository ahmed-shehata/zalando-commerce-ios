//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Quick
import Nimble
import AtlasMockAPI
@testable import AtlasUI
@testable import AtlasSDK

class SizeListSelectionViewControllerSpec: QuickSpec {

    override class func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer() // swiftlint:disable:this force_try
    }

    override class func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer() // swiftlint:disable:this force_try
    }

    override func spec() {
        describe("SizeListSelectionViewController") {

            it("should not a single unit article") {
                var sizeSelectionNavigationController: UINavigationController?
                waitUntil(timeout: 10) { done in
                    self.navigationController("AD541L009-G11") { navigationController in

                        let _ = navigationController.topViewController?.view // Load the view
                        sizeSelectionNavigationController = navigationController
                        done()
                    }
                }

                let viewController = sizeSelectionNavigationController?.topViewController as? SizeListSelectionViewController
                expect(viewController?.tableViewDataSource).toEventuallyNot(beNil())
                expect(viewController?.tableViewDataSource?.article.units.count).to(equal(5))
                expect(viewController?.tableViewDataSource?.article.availableUnits.count).to(equal(1))
                expect(viewController?.tableViewDataSource?.article.hasSingleUnit).to(equal(false))
                expect(sizeSelectionNavigationController?.topViewController).to(equal(viewController))
            }

            it("should be a single unit article") {
                var sizeSelectionNavigationController: UINavigationController?
                waitUntil(timeout: 10) { done in
                    self.navigationController("MK151F00E-Q11") { navigationController in

                        let _ = navigationController.topViewController?.view // Load the view
                        sizeSelectionNavigationController = navigationController
                        done()
                    }
                }

                let viewController = sizeSelectionNavigationController?.topViewController as? SizeListSelectionViewController
                expect(viewController?.tableViewDataSource).toEventuallyNot(beNil())
                expect(viewController?.tableViewDataSource?.article.units.count).to(equal(1))
                expect(viewController?.tableViewDataSource?.article.availableUnits.count).to(equal(1))
                expect(viewController?.tableViewDataSource?.article.hasSingleUnit).to(equal(true))
                expect(sizeSelectionNavigationController?.topViewController).toNot(equal(viewController))
            }

            it("should be out of stock") {
                var sizeSelectionNavigationController: UINavigationController?
                waitUntil(timeout: 10) { done in
                    self.navigationController("AZ711N00B-Q11") { navigationController in

                        let _ = navigationController.topViewController?.view // Load the view
                        sizeSelectionNavigationController = navigationController
                        done()
                    }
                }

                let viewController = sizeSelectionNavigationController?.topViewController as? SizeListSelectionViewController
                expect(UserMessage.errorDisplayed).toEventually(equal(true))
                expect(sizeSelectionNavigationController?.topViewController).to(equal(viewController))
            }

        }
    }

    private func navigationController(sku: String, completion: (UINavigationController -> Void)) {
        self.atlasCheckout { atlasCheckout in

            let viewController = SizeListSelectionViewController(checkout: atlasCheckout, sku: sku)
            let navigationController = UINavigationController(rootViewController: viewController)
            self.registerAtlasUIViewController(atlasCheckout, sku: sku)
            completion(navigationController)
        }
    }

    private func registerAtlasUIViewController(checkout: AtlasCheckout, sku: String) {
        let atlasUIViewController = AtlasUIViewController(atlasCheckout: checkout, forProductSKU: sku)
        Atlas.register { atlasUIViewController }
    }

    private func atlasCheckout(completion: (AtlasCheckout -> Void)) {
        let configURL = AtlasMockAPI.endpointURL(forPath: "/config")
        let interfaceLanguage = "en"
        let salesChannelId = "82fe2e7f-8c4f-4aa1-9019-b6bde5594456"
        let clientId = "CLIENT_ID"
        let options = Options(clientId: clientId,
                              salesChannel: salesChannelId,
                              interfaceLanguage: interfaceLanguage,
                              configurationURL: configURL)


        AtlasCheckout.configure(options) { result in
            guard let checkout = result.process() else { return XCTFail() }
            Async.main {
                completion(checkout)
            }
        }
    }

}
