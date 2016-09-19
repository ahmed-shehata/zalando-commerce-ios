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

    func testBuyProductWithSizesAndNavigatingBack() {
        let backButton = app.navigationBars["checkout-summary-navigation-bar"].buttons["Back"]
        let cancelButton = app.navigationBars["checkout-summary-navigation-bar"].buttons["Cancel"]
        let sizeText = app.cells["size-cell-XS"]

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
        tapBackToSummaryFromPickingAddressButton()
        tapPlaceOrder()
        tapBackToShop()

    }

    func testChangeBillingAddress() {
        let size = app.cells["size-cell-1"]

        tapBuyNow("Lamica")
        waitForElementToAppearAndTap(size)
        tapConnectAndLogin()
        changeBillingAddress()
        tapBackToSummaryFromPickingAddressButton()
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

    func testDeleteAddress() {
        let size = app.cells["size-cell-1"]
        tapBuyNow("Lamica")
        waitForElementToAppearAndTap(size)
        tapConnectAndLogin()
        app.otherElements["shipping-stack-view"].tap()
        deleteAddresses()
        app.buttons["navigation-bar-cancel-button"].tap()
    }

    private func deleteAddresses() {
        let rightButton = app.navigationBars.buttons["address-picker-right-button"]
        rightButton.tap()

        let tablesQuery = app.tables

        tablesQuery.buttons.elementBoundByIndex(0).tap()
        tablesQuery.buttons.elementBoundByIndex(2).tap()

        tablesQuery.buttons.elementBoundByIndex(0).tap()
        tablesQuery.buttons.elementBoundByIndex(2).tap()

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

    private func tapBackToSummaryFromPickingAddressButton() {
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
