//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import AtlasMockAPI

class AtlasCheckoutDemoUITests: XCTestCase {

    let app = XCUIApplication()

    override class func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer() // swiftlint:disable:this force_try
    }

    override class func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer() // swiftlint:disable:this force_try
    }

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        app.launchArguments = [AtlasMockAPI.isEnabledFlag]
        app.launch()
    }

    func testBuyQuicklyProductWithSizes() {
        let sizeText = app.tables.staticTexts["42"]
        let payButton = app.buttons["Pay €74,95"]

        tapBuyNow("Lamica")

        waitForElementToAppearAndTap(sizeText)
        waitForElementToAppearAndTap(payButton)
        waitForElementToAppearAndTap(doneButton)
    }

    func testBuyQuicklyProductWithoutSizes() {
        let payButton = app.buttons["Pay €109,95"]

        tapBuyNow("MICHAEL Michael Kors")

        waitForElementToAppearAndTap(payButton)
        waitForElementToAppearAndTap(doneButton)
    }

    func testBuyProductWithSizesAndNavigatingBack() {
        let summaryNavigationBar = app.navigationBars["Summary"]
        let backButton = summaryNavigationBar.buttons["Back"]
        let cancelButton = summaryNavigationBar.buttons["Cancel"]
        let sizeText = app.tables.staticTexts["XS"]

        let payButton = app.buttons["Pay €38,45"]

        tapBuyNow("Guess")

        waitForElementToAppearAndTap(sizeText)
        waitForElementToAppearAndTap(backButton)
        waitForElementToAppearAndTap(sizeText)
        waitForElementToAppearAndTap(cancelButton)

        tapBuyNow("Guess")

        waitForElementToAppearAndTap(sizeText)
        waitForElementToAppearAndTap(payButton)
        waitForElementToAppearAndTap(doneButton)
    }

    private var navigationController: XCUIElementQuery {
        return app.otherElements.containingType(.NavigationBar, identifier: "AtlasSDK Demo")
    }

    private var collectionView: XCUIElement {
        return navigationController.descendantsMatchingType(.CollectionView).element
    }

    private var doneButton: XCUIElement {
        return app.navigationBars["Payment"].buttons["Done"]
    }

    private func tapBuyNow(identifier: String) {
        let cell = collectionView.cells.otherElements.containingType(.StaticText, identifier: identifier)
        let buyNowButton = cell.buttons["BUY NOW"]
        collectionView.scrollToElement(buyNowButton)
        NSThread.sleepForTimeInterval(0.5)
        waitForElementToAppearAndTap(buyNowButton)
    }

}
