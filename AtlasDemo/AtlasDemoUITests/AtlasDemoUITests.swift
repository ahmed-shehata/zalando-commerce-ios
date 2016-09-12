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
        tapBuyNow("Lamica")

        waitForElementToAppearAndTap(app.tables.cells["size-cell-1"])
        tapConnectAndLogin()
        tapPlaceOrder()
        tapBackToShop()
    }

    func testBuyQuicklyProductWithoutSizes() {
        tapBuyNow("MICHAEL Michael Kors")

        tapConnectAndLogin()
        tapPlaceOrder()
        tapBackToShop()
    }

    func testDeleteAddress() {
        let sizeText = app.tables.staticTexts["42"] // TODO: change to accesibilityLabel
        tapBuyNow("Lamica")
        waitForElementToAppearAndTap(sizeText)
        tapConnectAndLogin()
        app.scrollViews.childrenMatchingType(.Any)
            .element.childrenMatchingType(.Any).elementBoundByIndex(2).staticTexts["Erika Mustermann, Mollstr. 1 10178 Berlin"].tap() // TODO: change to accesibilityLabel
        deleteAddresses()
        app.navigationBars["Summary"].buttons["Cancel"].tap() // TODO: change to accesibilityLabel
    }

    func testBuyProductWithSizesAndNavigatingBack() {
        let summaryNavigationBar = app.navigationBars["Summary"] // TODO: change to accesibilityLabel
        let backButton = summaryNavigationBar.buttons["Back"] // TODO: change to accesibilityLabel
        let cancelButton = summaryNavigationBar.buttons["Cancel"] // TODO: change to accesibilityLabel
        let sizeText = app.tables.staticTexts["XS"] // TODO: change to accesibilityLabel

        tapBuyNow("Guess")

        waitForElementToAppearAndTap(sizeText)
        waitForElementToAppearAndTap(backButton)
        waitForElementToAppearAndTap(sizeText)
        waitForElementToAppearAndTap(cancelButton)

        tapBuyNow("Guess")

        waitForElementToAppearAndTap(sizeText)

        tapConnectAndLogin()
        tapPlaceOrder()
        tapBackToShop()
    }

    func testChangeShippingAddress() {
        let sizeText = app.tables.staticTexts["42"] // TODO: change to accesibilityLabel

        tapBuyNow("Lamica")

        waitForElementToAppearAndTap(sizeText)
        tapConnectAndLogin()
        changeShippingAddress()
        tapBackToSummaryButton()
        tapPlaceOrder()
        tapBackToShop()

    }

    func testChangeBillingAddress() {
        let sizeText = app.tables.staticTexts["42"] // TODO: change to accesibilityLabel

        tapBuyNow("Lamica")
        waitForElementToAppearAndTap(sizeText)
        tapConnectAndLogin()
        changeBillingAddress()
        tapBackToSummaryButton()
        tapPlaceOrder()
        tapBackToShop()
    }

    func changeShippingAddress() {
        let tablesQuery = app.tables

        app.scrollViews.childrenMatchingType(.Any)
            .element.childrenMatchingType(.Any).elementBoundByIndex(2).staticTexts["Erika Mustermann, Mollstr. 1 10178 Berlin"].tap() // TODO: change to accesibilityLabel
        tablesQuery.cells.containingType(.StaticText, identifier: "Jane Doe").staticTexts["Mollstr. 1 10178 Berlin"].tap() // TODO: change to accesibilityLabel
    }

    func changeBillingAddress() {
        let tablesQuery = app.tables

        app.scrollViews.childrenMatchingType(.Any)
            .element.childrenMatchingType(.Any).elementBoundByIndex(4).staticTexts["Erika Mustermann, Mollstr. 1 10178 Berlin"].tap() // TODO: change to accesibilityLabel
        tablesQuery.cells.containingType(.StaticText, identifier: "Jane Doe").staticTexts["Mollstr. 1 10178 Berlin"].tap() // TODO: change to accesibilityLabel

    }

    private func deleteAddresses() {
        let shippingAddressNavigationBar = app.navigationBars["Shipping Address"] // TODO: change to accesibilityLabel
        shippingAddressNavigationBar.buttons["Edit"].tap() // TODO: change to accesibilityLabel
        let tablesQuery = app.tables

        tablesQuery.buttons["Delete Jane, Mollstr. 1 10178 Berlin"].tap() // TODO: change to accesibilityLabel
        tablesQuery.buttons["Delete"].tap() // TODO: change to accesibilityLabel

        tablesQuery.buttons["Delete John, Mollstr. 1 10178 Berlin"].tap() // TODO: change to accesibilityLabel
        tablesQuery.buttons["Delete"].tap() // TODO: change to accesibilityLabel
        app.navigationBars["Shipping Address"].buttons["Done"].tap() // TODO: change to accesibilityLabel
        shippingAddressNavigationBar.buttons["Summary"].tap() // TODO: change to accesibilityLabel

    }

    private func tapConnectAndLogin() {
        waitForElementToAppearAndTap(app.buttons["Checkout with Zalando"]) // TODO: change to accesibilityLabel
        fillInLogin()
    }

    private func tapPlaceOrder() {
        waitForElementToAppearAndTap(app.buttons["Place order"]) // TODO: change to accesibilityLabel
    }

    private func tapBackToSummaryButton() {
        waitForElementToAppearAndTap(app.buttons["Summary"]) // TODO: change to accesibilityLabel
    }

    private func tapBackToShop() {
        waitForElementToAppearAndTap(app.buttons["Back to shop"]) // TODO: change to accesibilityLabel
    }

    private func fillInLogin() {
        NSThread.sleepForTimeInterval(1)

        app.buttons["Login"].tap()
    }

    private func tapBuyNow(identifier: String) {
        let cell = collectionView.cells.otherElements.containingType(.StaticText, identifier: identifier)
        let buyNowButton = cell.buttons["buy-now"]
        collectionView.scrollToElement(buyNowButton)
        NSThread.sleepForTimeInterval(0.5)
        waitForElementToAppearAndTap(buyNowButton)
    }

    private var navigationController: XCUIElementQuery {
        return app.otherElements.containingType(.NavigationBar, identifier: "AtlasSDK Demo") // TODO: change to accesibilityLabel
    }

    private var collectionView: XCUIElement {
        return navigationController.descendantsMatchingType(.CollectionView).element
    }

}
