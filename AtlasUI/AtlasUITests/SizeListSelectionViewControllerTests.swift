//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasUI
@testable import AtlasSDK

class SizeListSelectionViewControllerTests: UITestCase {

    func testManySizesArticle() {
        let navigationController = createNavigationController(forSKU: "AD541L009-G11")
        _ = navigationController.topViewController?.view // Load the view

        let viewController = navigationController.topViewController as? SizeListSelectionViewController
        expect(viewController?.tableViewDataSource).toEventuallyNot(beNil())
        expect(viewController?.tableViewDataSource?.article.units.count) == 5
        expect(viewController?.tableViewDataSource?.article.availableUnits.count) == 1
        expect(viewController?.tableViewDataSource?.article.hasSingleUnit) == false
        expect(navigationController.topViewController) == viewController
    }

    func testSingleSizeArticle() {
        let navigationController = createNavigationController(forSKU: "MK151F00E-Q11")
        _ = navigationController.topViewController?.view // Load the view

        let viewController = navigationController.topViewController as? SizeListSelectionViewController
        expect(viewController?.tableViewDataSource).toEventuallyNot(beNil())
        expect(viewController?.tableViewDataSource?.article.units.count) == 1
        expect(viewController?.tableViewDataSource?.article.availableUnits.count) == 1
        expect(viewController?.tableViewDataSource?.article.hasSingleUnit).to(beTrue())
        expect(navigationController.topViewController).toEventuallyNot(equal(viewController))
    }

    func testOutOfStockArticle() {
        let navigationController = createNavigationController(forSKU: "AZ711N00B-Q11")
        _ = navigationController.topViewController?.view // Load the view

        let viewController = navigationController.topViewController as? SizeListSelectionViewController
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
        expect(navigationController.topViewController) == viewController
    }

}

extension SizeListSelectionViewControllerTests {

    fileprivate func createNavigationController(forSKU sku: String) -> UINavigationController {
        registerAtlasUIViewController(forSKU: sku)
        let viewController = SizeListSelectionViewController(sku: sku)
        return UINavigationController(rootViewController: viewController)
    }

    fileprivate func registerAtlasUIViewController(forSKU sku: String) {
        let atlasUIViewController = AtlasUIViewController(forSKU: sku)
        _ = atlasUIViewController.view // load the view
        try! AtlasUI.shared().register { atlasUIViewController }
    }

}
