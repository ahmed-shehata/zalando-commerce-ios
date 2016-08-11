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
        let payButton = app.buttons["Pay €74,95"]

        tapBuyNow("Lamica")

        waitForElementToAppearAndTap(sizeText)
        waitForElementToAppearAndTap(payButton)
        waitForElementToAppearAndTap(doneButton)
    }

    func testBuyQuicklyProductWithoutSizes() {
        tapBuyNow("MICHAEL Michael Kors")

        waitForElementToAppearAndTap(connectButton)
        waitForElementToAppearAndTap(buyNowButton)
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

    private var connectButton: XCUIElement {
        return app.buttons["Connect To Zalando"]
    }

    private var buyNowButton: XCUIElement {
        return app.buttons["Buy Now"]
    }

    private func fillInLogin() {
        let zalandoLoginElement = app.otherElements["Zalando Login"]
        let element = zalandoLoginElement.childrenMatchingType(.Other).elementBoundByIndex(4)
        element.childrenMatchingType(.TextField).element.tap()
        element.childrenMatchingType(.TextField).element.typeText("john.doe.lucky@zalando.de")
        element.childrenMatchingType(.TextField).element

        let element2 = zalandoLoginElement.childrenMatchingType(.Other).elementBoundByIndex(7)
        element2.childrenMatchingType(.SecureTextField).element.tap()
        element.childrenMatchingType(.TextField).element.typeText("1234568")
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

}
