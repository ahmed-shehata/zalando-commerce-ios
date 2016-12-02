//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble
import AtlasMockAPI

@testable import AtlasUI
@testable import AtlasSDK

class GuestSummaryActionHandlerTests: XCTestCase {

    var mockedDataSource: GuestSummaryActionHandlerDataSourceMocked?
    var actionHandler: GuestCheckoutSummaryActionHandler?

    override func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer()
        actionHandler = createActionHandler()
    }

    override func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer()
    }

    func testSubmitButtonWithMissingAddress() {
        actionHandler?.handleSubmitButton()
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testSubmitButtonWithMissingPayment() {
        guard let dataModel = mockedDataSource?.dataModel else { return fail() }
        mockedDataSource?.dataModel = addAddress(toDataModel: dataModel)
        actionHandler?.handleSubmitButton()
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testPaymentButtonWithMissingAddress() {
        actionHandler?.showPaymentSelectionScreen()
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testPaymentButtonWithPaymentError() {
        guard let dataModel = mockedDataSource?.dataModel else { return fail() }
        mockedDataSource?.dataModel = addAddress(toDataModel: dataModel)
        guard let paymentViewController = showPaymentScreen() else { return fail() }
        paymentViewController.paymentCompletion?(.error)
        AtlasUIViewController.instance?.mainNavigationController.popViewControllerAnimated(true)
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testPaymentButtonWithPaymentSuccess() {
        selectedPaymentMethod()
        expect(UserMessage.errorDisplayed).toEventually(beFalse())
    }

}

extension GuestSummaryActionHandlerTests {

    private func createActionHandler() -> GuestCheckoutSummaryActionHandler? {
        var guestActionHandler: GuestCheckoutSummaryActionHandler?
        waitUntil(timeout: 10) { done in
            let sku = "AD541L009-G11"
            self.registerAtlasUIViewController(sku) {
                AtlasUIClient.article(sku) { result in
                    guard let article = result.process() else { return fail() }
                    let selectedArticleUnit = SelectedArticleUnit(article: article, selectedUnitIndex: 0)
                    self.mockedDataSource = GuestSummaryActionHandlerDataSourceMocked(selectedArticleUnit: selectedArticleUnit)
                    guestActionHandler = GuestCheckoutSummaryActionHandler(email: "john.doe@zalando.de")
                    guestActionHandler?.dataSource = self.mockedDataSource
                    done()
                }
            }
        }
        return guestActionHandler
    }

    private func registerAtlasUIViewController(sku: String, completion: () -> Void) {
        let options = Options(clientId: "CLIENT_ID",
                              salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                              interfaceLanguage: "en",
                              configurationURL: AtlasMockAPI.endpointURL(forPath: "/config"))

        AtlasUI.configure(options) { _ in
            let atlasUIViewController = AtlasUIViewController(forProductSKU: sku)
            AtlasUI.register { atlasUIViewController }
            let _  = atlasUIViewController.view // load the view
            completion()
        }
    }

    private func createAddress() -> GuestCheckoutAddress {
        return GuestCheckoutAddress(id: "",
                                    gender: .male,
                                    firstName: "John",
                                    lastName: "Doe",
                                    street: "Mollstr. 1",
                                    additional: nil,
                                    zip: "10178",
                                    city: "Berlin",
                                    countryCode: "DE",
                                    pickupPoint: nil)
    }

    private func addAddress(toDataModel dataModel: CheckoutSummaryDataModel) -> CheckoutSummaryDataModel {
        return CheckoutSummaryDataModel(selectedArticleUnit: dataModel.selectedArticleUnit,
                                        shippingAddress: createAddress(),
                                        billingAddress: createAddress(),
                                        paymentMethod: dataModel.paymentMethod,
                                        shippingPrice: dataModel.shippingPrice,
                                        totalPrice: dataModel.totalPrice,
                                        delivery: dataModel.delivery,
                                        email: dataModel.email)
    }

    private func showPaymentScreen() -> PaymentViewController? {
        actionHandler?.showPaymentSelectionScreen()
        expect(AtlasUIViewController.instance?.mainNavigationController.viewControllers.last as? PaymentViewController).toNotEventually(beNil())
        return AtlasUIViewController.instance?.mainNavigationController.viewControllers.last as? PaymentViewController
    }

    private func selectedPaymentMethod() {
        guard let dataModel = mockedDataSource?.dataModel else { return fail() }
        mockedDataSource?.dataModel = addAddress(toDataModel: dataModel)
        guard let paymentViewController = showPaymentScreen() else { return fail() }
        paymentViewController.paymentCompletion?(.guestRedirect(encryptedCheckoutId: "CHECKOUT_ID", encryptedToken: "TOKEN"))
        AtlasUIViewController.instance?.mainNavigationController.popViewControllerAnimated(true)
    }

}

class GuestSummaryActionHandlerDataSourceMocked: NSObject, CheckoutSummaryActionHandlerDataSource {

    var dataModel: CheckoutSummaryDataModel

    init(selectedArticleUnit: SelectedArticleUnit) {
        dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit, totalPrice: 0)
    }

}
