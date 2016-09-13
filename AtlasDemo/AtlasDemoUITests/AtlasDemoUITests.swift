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
        let size = app.cells["size-cell-1"]
        tapBuyNow("Lamica")
        waitForElementToAppearAndTap(size)
        tapConnectAndLogin()
        app.otherElements["shipping-stack-view"].tap()
        deleteAddresses()
        app.buttons["navigation-bar-cancel-button"].tap()
    }

    func testBuyProductWithSizesAndNavigatingBack() {
        let backButton = app.navigationBars["catalog-navigation-controller"].buttons["Back"]
        let cancelButton = app.navigationBars["catalog-navigation-controller"].buttons["Cancel"]
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
        let size = app.cells["size-cell-1"]

        tapBuyNow("Lamica")

        waitForElementToAppearAndTap(size)
        tapConnectAndLogin()
        changeShippingAddress()
        tapBackToSummaryButton()
        tapPlaceOrder()
        tapBackToShop()

    }

    func testChangeBillingAddress() {
        let size = app.cells["size-cell-1"]

        tapBuyNow("Lamica")
        waitForElementToAppearAndTap(size)
        tapConnectAndLogin()
        changeBillingAddress()
        tapBackToSummaryButton()
        tapPlaceOrder()
        tapBackToShop()
    }

    func changeShippingAddress() {
        app.otherElements["shipping-stack-view"].tap()
        app.cells["address-selection-row-1"].tap()
    }

    func changeBillingAddress() {
        app.otherElements["billing-stack-view"].tap()
        app.cells["address-selection-row-1"].tap()
    }

    private func deleteAddresses() {
        let rightButton = app.navigationBars.buttons["address-picker-right-button"]
        rightButton.tap()

        let tablesQuery = app.tables

        app.cells["address-selection-row-1"].tap()
        tablesQuery.buttons.elementBoundByIndex(1).tap()
        tablesQuery.buttons["Delete"].tap()

        tablesQuery.buttons.elementBoundByIndex(1).tap()
        tablesQuery.buttons["Delete"].tap()

        rightButton.tap()
        app.navigationBars["address-picker-navigation-bar"].buttons["Back"].tap()
    }

    private func tapConnectAndLogin() {
        waitForElementToAppearAndTap(app.buttons["checkout-footer-button"])
        fillInLogin()
        NSThread.sleepForTimeInterval(1)
    }

    private func tapPlaceOrder() {
        waitForElementToAppearAndTap(app.buttons["checkout-footer-button"])
    }

    private func tapBackToSummaryButton() {
        waitForElementToAppearAndTap(app.navigationBars["address-picker-navigation-bar"].buttons["Back"])
    }

    private func tapBackToShop() {
        waitForElementToAppearAndTap(app.buttons["checkout-footer-button"])
    }

    private func fillInLogin() {
        NSThread.sleepForTimeInterval(1)

        app.buttons["Login"].tap()
    }

    private func tapBuyNow(identifier: String) {
        let collectionView = app.collectionViews.elementBoundByIndex(0)
        let cell = collectionView.cells.otherElements.containingType(.StaticText, identifier: identifier)
        let buyNowButton = cell.buttons["buy-now"]
        collectionView.scrollToElement(buyNowButton)
        NSThread.sleepForTimeInterval(0.5)
        waitForElementToAppearAndTap(buyNowButton)
    }

    private var navigationController: XCUIElementQuery {
        return app.otherElements.containingType(.NavigationBar, identifier: "catalog-navigation-controller")
    }

    private var collectionView: XCUIElement {
        return navigationController.descendantsMatchingType(.CollectionView).element
    }
}
