//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import MockAPI

class AtlasDemoUITests: XCTestCase {

    let app = XCUIApplication()

    override class func setUp() {
        super.setUp()
        try! MockAPI.startServer()
    }

    override class func tearDown() {
        super.tearDown()
        try! MockAPI.stopServer()
    }

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        app.launchArguments = [MockAPI.isEnabledFlag, "UI_TESTS"]
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
        let cancelButton = app.navigationBars["checkout-summary-navigation-bar"].buttons["Cancel"]
        let sizeText = app.cells["size-cell-XL"]

        tapBuyNow(withId: "Guess")

        waitForAppearAndTap(element: sizeText)
        waitForAppearAndTap(element: cancelButton)

        tapBuyNow(withId: "Guess")

        waitForAppearAndTap(element: sizeText)

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
        let size = app.cells["size-cell-0"]
        tapBuyNow(withId: "Lamica")
        waitForAppearAndTap(element: size)
        tapConnectAndLogin()
        app.otherElements["shipping-stack-view"].tap()
        deleteAddresses()
        app.buttons["navigation-bar-cancel-button"].tap()
    }

    func testDeletePreselectedAddress() {
        let size = app.cells["size-cell-0"]
        tapBuyNow(withId: "Lamica")
        waitForAppearAndTap(element: size)
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
        let size = app.cells["size-cell-0"]
        let webView = app.otherElements["toc-webview"]
        tapBuyNow(withId: "Lamica")
        waitForAppearAndTap(element: size)
        app.buttons["checkout-summary-toc-button"].tap()
        waitForAppearAndTap(element: webView)
    }

    func testPickupPoints() {
        proceedToSummaryWithSizes()
        app.otherElements["shipping-stack-view"].tap()

        let shippingPredicate = NSPredicate(format: "count == 4")
        expectation(for: shippingPredicate, evaluatedWith: app.tables.cells, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        app.navigationBars["address-picker-navigation-bar"].buttons["Back"].tap()
        app.otherElements["billing-stack-view"].tap()

        let billingPredicate = NSPredicate(format: "count == 3")
        expectation(for: billingPredicate, evaluatedWith: app.tables.cells, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSaveOrderImage() {
        proceedToSummaryWithSizes()
        tapPlaceOrder()

        addUIInterruptionMonitor(withDescription: "Photos Dialog") { (alert) -> Bool in
            alert.buttons["OK"].tap()
            return true
        }

        waitForAppearAndTap(element: app.buttons["save-order-image-button"])
        app.tap()
    }

}

extension AtlasDemoUITests {

    fileprivate func proceedToSummaryWithSizes() {
        let size = app.cells["size-cell-0"]
        tapBuyNow(withId: "Lamica")
        waitForAppearAndTap(element: size)
        tapConnectAndLogin()
    }

    fileprivate func proceedToSummaryWithoutSizes() {
        tapBuyNow(withId: "MICHAEL Michael Kors")
        tapConnectAndLogin()
    }

    fileprivate func changeShippingAddress() {
        app.otherElements["shipping-stack-view"].tap()
        app.cells["address-selection-row-1"].tap()
    }

    fileprivate func changeBillingAddress() {
        app.otherElements["billing-stack-view"].tap()
        app.cells["address-selection-row-1"].tap()
    }

    fileprivate func deleteAddresses() {
        let rightButton = app.navigationBars.buttons["address-picker-right-button"]
        rightButton.tap()

        let table = app.tables

        table.buttons.element(boundBy: 2).tap()
        table.buttons.element(boundBy: 4).tap()

        table.buttons.element(boundBy: 2).tap()
        table.buttons.element(boundBy: 4).tap()

        let existsPredicate = NSPredicate(format: "count == 2")
        expectation(for: existsPredicate, evaluatedWith: table.cells, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        rightButton.tap()
        app.navigationBars["address-picker-navigation-bar"].buttons["Back"].tap()
    }

    fileprivate func editAddress() {
        let rightButton = app.navigationBars.buttons["address-picker-right-button"]
        rightButton.tap()
        app.tables.buttons.element(boundBy: 1).tap()
        app.navigationBars.buttons["address-edit-right-button"].tap()
        app.navigationBars["address-picker-navigation-bar"].buttons["Back"].tap()
    }

    fileprivate func createAddress() {
        app.cells["addresses-table-create-address-cell"].tap()
        app.buttons["Standard"].tap()

        app.textFields["title-textfield"].tap()
        app.pickerWheels.element.adjust(toPickerWheelValue: "Mr")

        app.textFields["firstname-textfield"].tap()
        setTextField(identifier: "firstname-textfield", value: "John")
        setTextField(identifier: "lastname-textfield", value: "Doe")
        setTextField(identifier: "street-textfield", value: "Mollstr. 1")
        setTextField(identifier: "additional-textfield", value: "Zalando SE")
        setTextField(identifier: "zipcode-textfield", value: "10178")
        setTextField(identifier: "city-textfield", value: "Berlin")

        app.navigationBars.buttons["address-edit-right-button"].tap()
    }

    fileprivate func setTextField(identifier: String, value: String) {
        app.textFields[identifier].typeText(value)
        app.textFields[identifier].typeText("\n")
    }

    fileprivate func tapConnectAndLogin() {
        waitForAppearAndTap(element: app.buttons["checkout-footer-button"])
        fillInLogin()
        Thread.sleep(forTimeInterval: 1)
    }

    fileprivate func tapPlaceOrder() {
        waitForAppearAndTap(element: app.buttons["checkout-footer-button"])
    }

    fileprivate func tapBackToShop() {
        waitForAppearAndTap(element: app.buttons["checkout-footer-button"])
    }

    fileprivate func fillInLogin() {
        Thread.sleep(forTimeInterval: 1)

        app.buttons["Login"].tap()
    }

    fileprivate func tapBuyNow(withId identifier: String) {
        let collectionView = app.collectionViews.element(boundBy: 0)
        let cell = collectionView.cells.otherElements.containing(.staticText, identifier: identifier)
        let buyNowButton = cell.buttons["buy-now"]
        collectionView.scrollTo(element: buyNowButton)
        Thread.sleep(forTimeInterval: 0.5)
        waitForAppearAndTap(element: buyNowButton)
    }

    fileprivate var navigationController: XCUIElementQuery {
        return app.otherElements.containing(.navigationBar, identifier: "catalog-navigation-controller")
    }

    fileprivate var collectionView: XCUIElement {
        return navigationController.descendants(matching: .collectionView).element
    }

}
