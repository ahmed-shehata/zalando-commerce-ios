//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble
import AtlasMockAPI

@testable import AtlasUI
@testable import AtlasSDK

class SizeListSelectionViewControllerTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer()
    }

    override class func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer()
    }

    func testManySizesArticle() {
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

    func testSingleSizeArticle() {
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
        expect(viewController?.tableViewDataSource?.article.hasSingleUnit).to(beTrue())
        expect(sizeSelectionNavigationController?.topViewController).toEventuallyNot(equal(viewController))
    }

    func testOutOfStockArticle() {
        var sizeSelectionNavigationController: UINavigationController?
        waitUntil(timeout: 10) { done in
            self.navigationController("AZ711N00B-Q11") { navigationController in

                let _ = navigationController.topViewController?.view // Load the view
                sizeSelectionNavigationController = navigationController
                done()
            }
        }

        let viewController = sizeSelectionNavigationController?.topViewController as? SizeListSelectionViewController
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
        expect(sizeSelectionNavigationController?.topViewController).to(equal(viewController))
    }

}

extension SizeListSelectionViewControllerTests {

    fileprivate func navigationController(_ sku: String, completion: @escaping ((UINavigationController) -> Void)) {
        registerAtlasUIViewController(sku) {
            let viewController = SizeListSelectionViewController(sku: sku)
            let navigationController = UINavigationController(rootViewController: viewController)
            completion(navigationController)
        }
    }

    fileprivate func registerAtlasUIViewController(_ sku: String, completion: @escaping () -> Void) {
        let options = Options(clientId: "CLIENT_ID",
                              salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                              interfaceLanguage: "en",
                              configurationURL: AtlasMockAPI.endpointURL(forPath: "/config"))

        AtlasUI.configure(options: options) { _ in
            let atlasUIViewController = AtlasUIViewController(forSKU: sku)
            AtlasUI.register { atlasUIViewController }
            completion()
        }
    }

}
