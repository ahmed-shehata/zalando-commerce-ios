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

    func testDeleteAddress() {
        let sizeText = app.tables.staticTexts["42"]
        tapBuyNow("Lamica")
        waitForElementToAppearAndTap(sizeText)
        tapConnectAndLogin()
        app.scrollViews.childrenMatchingType(.Any)
            .element.childrenMatchingType(.Any).elementBoundByIndex(2).staticTexts["Erika Mustermann, Mollstr. 1 10178 Berlin"].tap()
        deleteAddresses()
        app.navigationBars["Summary"].buttons["Cancel"].tap()
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

    func changeShippingAddress() {
        let tablesQuery = app.tables

        app.scrollViews.childrenMatchingType(.Any)
            .element.childrenMatchingType(.Any).elementBoundByIndex(2).staticTexts["Erika Mustermann, Mollstr. 1 10178 Berlin"].tap()
        tablesQuery.cells.containingType(.StaticText, identifier: "Jane").staticTexts["Mollstr. 1 10178 Berlin "].tap()
    }

    func changeBillingAddress() {
        let tablesQuery = app.tables

        app.scrollViews.childrenMatchingType(.Any)
            .element.childrenMatchingType(.Any).elementBoundByIndex(4).staticTexts["Erika Mustermann, Mollstr. 1 10178 Berlin"].tap()
        tablesQuery.cells.containingType(.StaticText, identifier: "Jane").staticTexts["Mollstr. 1 10178 Berlin "].tap()

    }

    private func deleteAddresses() {
        let shippingAddressNavigationBar = app.navigationBars["Shipping Address"]
        shippingAddressNavigationBar.buttons["Edit"].tap()
        let tablesQuery = app.tables

        tablesQuery.buttons["Delete Jane, Mollstr. 1 10178 Berlin"] .tap()
        tablesQuery.buttons["Delete"] .tap()

        tablesQuery.buttons["Delete John, Mollstr. 1 10178 Berlin"] .tap()
        tablesQuery.buttons["Delete"] .tap()
        app.navigationBars["Shipping Address"].buttons["Done"].tap()
        shippingAddressNavigationBar.buttons["Summary"].tap()

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

        app.buttons["Login"].tap()
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
