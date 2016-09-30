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
        proceedToSummaryWithSizes()
        tapPlaceOrder()
        tapBackToShop()
    }

    func testBuyQuicklyProductWithoutSizes() {
        proceedToSummaryWithoutSizes()
        tapPlaceOrder()
        tapBackToShop()
    }

    func testBuyProductWithSizesAndNavigatingBack() {
        let backButton = app.navigationBars["checkout-summary-navigation-bar"].buttons["Back"]
        let cancelButton = app.navigationBars["checkout-summary-navigation-bar"].buttons["Cancel"]
        let sizeText = app.cells["size-cell-XL"]

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
        proceedToSummaryWithSizes()
        changeShippingAddress()
        tapPlaceOrder()
        tapBackToShop()

    }

    func testChangeBillingAddress() {
        proceedToSummaryWithSizes()
        changeBillingAddress()
        tapPlaceOrder()
        tapBackToShop()
    }

    func testCreateAddress() {
        proceedToSummaryWithSizes()
        app.otherElements["shipping-stack-view"].tap()
        createAddress()
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

    func testDeletePreselectedAddress() {
        let size = app.cells["size-cell-1"]
        tapBuyNow("Lamica")
        waitForElementToAppearAndTap(size)
        tapConnectAndLogin()

        app.otherElements["shipping-stack-view"].tap()
        deleteAddresses()
        changeShippingAddress()
        changeBillingAddress()

        tapPlaceOrder()
        tapBackToShop()

    }

    func testEditAddress() {
        proceedToSummaryWithSizes()
        app.otherElements["shipping-stack-view"].tap()
        editAddress()
        app.buttons["navigation-bar-cancel-button"].tap()
    }

    func testToC() {
        let size = app.cells["size-cell-1"]
        let webView = app.otherElements["toc-webview"]
        tapBuyNow("Lamica")
        waitForElementToAppearAndTap(size)
        app.buttons["checkout-summary-toc-button"].tap()
        waitForElementToAppearAndTap(webView)
    }

    func testPickupPoints() {
        proceedToSummaryWithSizes()
        app.otherElements["shipping-stack-view"].tap()

        let shippingPredicate = NSPredicate(format: "count == 4")
        expectationForPredicate(shippingPredicate, evaluatedWithObject: app.tables.cells, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)

        app.navigationBars["address-picker-navigation-bar"].buttons["Back"].tap()
        app.otherElements["billing-stack-view"].tap()

        let billingPredicate = NSPredicate(format: "count == 3")
        expectationForPredicate(billingPredicate, evaluatedWithObject: app.tables.cells, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)
    }
}

extension AtlasDemoUITests {

    private func proceedToSummaryWithSizes() {
        let size = app.cells["size-cell-1"]
        tapBuyNow("Lamica")
        waitForElementToAppearAndTap(size)
        tapConnectAndLogin()
    }

    private func proceedToSummaryWithoutSizes() {
        tapBuyNow("MICHAEL Michael Kors")
        tapConnectAndLogin()
    }

    private func changeShippingAddress() {
        app.otherElements["shipping-stack-view"].tap()
        app.cells["address-selection-row-1"].tap()
    }

    private func changeBillingAddress() {
        app.otherElements["billing-stack-view"].tap()
        app.cells["address-selection-row-1"].tap()
    }

    private func deleteAddresses() {
        let rightButton = app.navigationBars.buttons["address-picker-right-button"]
        rightButton.tap()

        let table = app.tables

        table.buttons.elementBoundByIndex(0).tap()
        table.buttons.elementBoundByIndex(2).tap()

        table.buttons.elementBoundByIndex(0).tap()
        table.buttons.elementBoundByIndex(2).tap()

        let existsPredicate = NSPredicate(format: "count == 2")
        expectationForPredicate(existsPredicate, evaluatedWithObject: table.cells, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)

        rightButton.tap()
        app.navigationBars["address-picker-navigation-bar"].buttons["Back"].tap()
    }

    private func editAddress() {
        let rightButton = app.navigationBars.buttons["address-picker-right-button"]
        rightButton.tap()
        app.tables.buttons.elementBoundByIndex(1).tap()
        app.navigationBars.buttons["address-edit-right-button"].tap()
        app.navigationBars["address-picker-navigation-bar"].buttons["Back"].tap()
    }

    private func createAddress() {
        app.cells["addresses-table-create-address-cell"].tap()
        app.buttons["Standard"].tap()

        app.textFields["title-textfield"].tap()
        app.pickerWheels.element.adjustToPickerWheelValue("Mr")

        app.textFields["firstname-textfield"].tap()
        setTextFieldValue("firstname-textfield", value: "John")
        setTextFieldValue("lastname-textfield", value: "Doe")
        setTextFieldValue("street-textfield", value: "Mollstr. 1")
        setTextFieldValue("additional-textfield", value: "")
        setTextFieldValue("zipcode-textfield", value: "10178")
        setTextFieldValue("city-textfield", value: "Berlin")

        app.navigationBars.buttons["address-edit-right-button"].tap()
        app.navigationBars["address-picker-navigation-bar"].buttons["Back"].tap()
    }

    private func setTextFieldValue(textFieldIdentifier: String, value: String) {
        app.textFields[textFieldIdentifier].typeText(value)
        app.textFields[textFieldIdentifier].typeText("\n")
    }

    private func tapConnectAndLogin() {
        waitForElementToAppearAndTap(app.buttons["checkout-footer-button"])
        fillInLogin()
        NSThread.sleepForTimeInterval(1)
    }

    private func tapPlaceOrder() {
        waitForElementToAppearAndTap(app.buttons["checkout-footer-button"])
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
