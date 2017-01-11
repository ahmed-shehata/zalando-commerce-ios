//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasUI
@testable import AtlasSDK

class SizeListSelectionViewControllerTests: UITestCase {

    func testManySizesArticle() {
        registerAtlasUIViewController(forSKU: "AD541L009-G11")

        let viewController = self.atlasUIViewController?.mainNavigationController.topViewController as? SizeListSelectionViewController
        expect(viewController?.tableViewDataSource).toEventuallyNot(beNil())
        expect(viewController?.tableViewDataSource?.article.units.count) == 5
        expect(viewController?.tableViewDataSource?.article.availableUnits.count) == 1
        expect(viewController?.tableViewDataSource?.article.hasSingleUnit) == false
        expect(self.atlasUIViewController?.mainNavigationController.topViewController).toEventually(equal(viewController))
    }

    func testSingleSizeArticle() {
        registerAtlasUIViewController(forSKU: "MK151F00E-Q11")

        let viewController = self.atlasUIViewController?.mainNavigationController.topViewController as? SizeListSelectionViewController
        expect(viewController?.tableViewDataSource).toEventuallyNot(beNil(), timeout: 10)
        expect(viewController?.tableViewDataSource?.article.units.count) == 1
        expect(viewController?.tableViewDataSource?.article.availableUnits.count) == 1
        expect(viewController?.tableViewDataSource?.article.hasSingleUnit).to(beTrue())
        expect(self.atlasUIViewController?.mainNavigationController.topViewController).toEventuallyNot(equal(viewController))
    }

    func testOutOfStockArticle() {
        registerAtlasUIViewController(forSKU: "AZ711N00B-Q11")

        let viewController = self.atlasUIViewController?.mainNavigationController.topViewController as? SizeListSelectionViewController
        expect(self.errorDisplayed).toEventually(beTrue())
        expect(self.atlasUIViewController?.mainNavigationController.topViewController).toEventually(equal(viewController))
    }

}
