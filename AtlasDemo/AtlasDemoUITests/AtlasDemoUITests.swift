//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import AtlasMockAPI

class AtlasDemoUITests: XCTestCase {

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

        tapBuyNow("Lamica")

        waitForElementToAppearAndTap(sizeText)
        tapConnectAndLogin()
        tapBuyNow()
        tapBackToShop()
    }

    func testBuyQuicklyProductWithoutSizes() {
        tapBuyNow("MICHAEL Michael Kors")

        tapConnectAndLogin()
        tapBuyNow()
        tapBackToShop()
    }

    func testBuyProductWithSizesAndNavigatingBack() {
        let summaryNavigationBar = app.navigationBars["Summary"]
        let backButton = summaryNavigationBar.buttons["Back"]
        let cancelButton = summaryNavigationBar.buttons["Cancel"]
        let sizeText = app.tables.staticTexts["XS"]

        tapBuyNow("Guess")

        waitForElementToAppearAndTap(sizeText)
        waitForElementToAppearAndTap(backButton)
        waitForElementToAppearAndTap(sizeText)
        waitForElementToAppearAndTap(cancelButton)

        tapBuyNow("Guess")

        waitForElementToAppearAndTap(sizeText)

        tapConnectAndLogin()
        tapBuyNow()
        tapBackToShop()
    }

    func testChangeShippingAddress() {
        let sizeText = app.tables.staticTexts["42"]

        tapBuyNow("Lamica")

        waitForElementToAppearAndTap(sizeText)
        tapConnectAndLogin()
        changeShippingAddress()
        tapBackToSummaryButton()
        tapBuyNow()
        tapBackToShop()

    }

    func testChangeBillingAddress() {
        let sizeText = app.tables.staticTexts["42"]

        tapBuyNow("Lamica")
        waitForElementToAppearAndTap(sizeText)
        tapConnectAndLogin()
        changeBillingAddress()
        tapBackToSummaryButton()
        tapBuyNow()
        tapBackToShop()

    }

    private func changeShippingAddress() {
        let tablesQuery = app.tables

        app.scrollViews.childrenMatchingType(.Other)
            .element.childrenMatchingType(.Other).elementBoundByIndex(2).staticTexts["Erika Mustermann, Mollstr. 1 10178 Berlin"].tap()
        tablesQuery.staticTexts["Jane Doe, Mollstr. 1 10178 Berlin "] .tap()
    }

    private func changeBillingAddress() {
        let tablesQuery = app.tables

        app.scrollViews.childrenMatchingType(.Other)
            .element.childrenMatchingType(.Other).elementBoundByIndex(4).staticTexts["Erika Mustermann, Mollstr. 1 10178 Berlin"].tap()
        tablesQuery.staticTexts["John Doe, Mollstr. 1 10178 Berlin "] .tap()
    }

    private func tapConnectAndLogin() {
        waitForElementToAppearAndTap(app.buttons["Checkout with Zalando"])
        fillInLogin()
        NSThread.sleepForTimeInterval(2)
    }

    private func tapBuyNow() {
        waitForElementToAppearAndTap(app.buttons["Place order"])
    }

    private func tapBackToSummaryButton() {
        waitForElementToAppearAndTap(app.buttons["Summary"])
    }

    private func tapBackToShop() {
        waitForElementToAppearAndTap(app.buttons["Back to shop"])
    }

    private func fillInLogin() {
        NSThread.sleepForTimeInterval(2)

        let zalandoLoginElement = app.otherElements["Zalando Login"]
        let element = zalandoLoginElement.childrenMatchingType(.Other).elementBoundByIndex(4)
        element.childrenMatchingType(.TextField).element.tap()
        element.childrenMatchingType(.TextField).element.typeText("atlas-testing@mailinator.com")
        element.childrenMatchingType(.TextField).element

        let element2 = zalandoLoginElement.childrenMatchingType(.Other).elementBoundByIndex(6)
        element2.childrenMatchingType(.SecureTextField).element.tap()
        element2.childrenMatchingType(.SecureTextField).element.typeText("12345678")
        element2.childrenMatchingType(.SecureTextField).element
        app.buttons["LOGIN"].tap()
    }

    private func tapBuyNow(identifier: String) {
        let cell = collectionView.cells.otherElements.containingType(.StaticText, identifier: identifier)
        let buyNowButton = cell.buttons["BUY NOW"]
        collectionView.scrollToElement(buyNowButton)
        NSThread.sleepForTimeInterval(0.5)
        waitForElementToAppearAndTap(buyNowButton)
    }

    private var navigationController: XCUIElementQuery {
        return app.otherElements.containingType(.NavigationBar, identifier: "AtlasSDK Demo")
    }

    private var collectionView: XCUIElement {
        return navigationController.descendantsMatchingType(.CollectionView).element
    }

}
