//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasUI
@testable import AtlasSDK

class GuestSummaryActionHandlerTests: UITestCase {

    var mockedDataSourceDelegate: GuestSummaryActionHandlerDataSourceDelegateMocked?
    var actionHandler: GuestCheckoutSummaryActionHandler?

    override func setUp() {
        super.setUp()
        registerAtlasUIViewController(sku: "AD541L009-G11")
        actionHandler = createActionHandler()
    }

    func testSubmitButtonWithMissingAddress() {
        actionHandler?.handleSubmit()
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testSubmitButtonWithMissingPayment() {
        guard let dataModel = mockedDataSourceDelegate?.dataModel else { return fail() }
        mockedDataSourceDelegate?.dataModel = addAddress(toDataModel: dataModel)
        actionHandler?.handleSubmit()
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testSubmitButton() {
        guard let dataModel = mockedDataSourceDelegate?.dataModel else { return fail() }
        mockedDataSourceDelegate?.dataModel = addAddress(toDataModel: dataModel)
        selectedPaymentMethod()
        expect(self.actionHandler?.guestCheckout).toNotEventually(beNil())
        actionHandler?.handleSubmit()
        expect(UserMessage.errorDisplayed).toEventually(beFalse())
        expect(self.mockedDataSourceDelegate?.layout as? GuestOrderPlacedLayout).toNotEventually(beNil())
    }

    func testPaymentButtonWithMissingAddress() {
        actionHandler?.handlePaymentSelection()
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testPaymentButtonWithPaymentError() {
        guard let dataModel = mockedDataSourceDelegate?.dataModel else { return fail() }
        mockedDataSourceDelegate?.dataModel = addAddress(toDataModel: dataModel)
        guard let paymentViewController = showPaymentScreen() else { return fail() }
        paymentViewController.paymentCompletion?(.error)
        _ = AtlasUIViewController.shared?.mainNavigationController.popViewController(animated: true)
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testPaymentButtonWithPaymentSuccess() {
        selectedPaymentMethod()
        expect(UserMessage.errorDisplayed).toEventually(beFalse())
    }

}

extension GuestSummaryActionHandlerTests {

    fileprivate func createActionHandler() -> GuestCheckoutSummaryActionHandler? {
        var guestActionHandler: GuestCheckoutSummaryActionHandler?
        waitUntil(timeout: 10) { done in
            AtlasUIClient.article(withSKU: "AD541L009-G11") { result in
                guard let article = result.process() else { return fail() }
                let selectedArticleUnit = SelectedArticleUnit(article: article, selectedUnitIndex: 0)
                self.mockedDataSourceDelegate = GuestSummaryActionHandlerDataSourceDelegateMocked(selectedArticleUnit: selectedArticleUnit)
                guestActionHandler = GuestCheckoutSummaryActionHandler(email: "john.doe@zalando.de")
                guestActionHandler?.dataSource = self.mockedDataSourceDelegate
                guestActionHandler?.delegate = self.mockedDataSourceDelegate
                done()
            }
        }
        return guestActionHandler
    }

    fileprivate func registerAtlasUIViewController(sku: String) {
        let atlasUIViewController = AtlasUIViewController(forSKU: sku)
        _  = atlasUIViewController.view // load the view
        try! AtlasUI.shared().register { atlasUIViewController }
    }

    fileprivate func createAddress() -> GuestCheckoutAddress {
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

    fileprivate func addAddress(toDataModel dataModel: CheckoutSummaryDataModel) -> CheckoutSummaryDataModel {
        return CheckoutSummaryDataModel(selectedArticleUnit: dataModel.selectedArticleUnit,
                                        shippingAddress: createAddress(),
                                        billingAddress: createAddress(),
                                        paymentMethod: dataModel.paymentMethod,
                                        totalPrice: dataModel.totalPrice,
                                        delivery: dataModel.delivery,
                                        email: dataModel.email)
    }

    fileprivate func showPaymentScreen() -> PaymentViewController? {
        actionHandler?.handlePaymentSelection()
        expect(AtlasUIViewController.shared?.mainNavigationController.viewControllers.last as? PaymentViewController).toNotEventually(beNil())
        return AtlasUIViewController.shared?.mainNavigationController.viewControllers.last as? PaymentViewController
    }

    fileprivate func selectedPaymentMethod() {
        guard let dataModel = mockedDataSourceDelegate?.dataModel else { return fail() }
        mockedDataSourceDelegate?.dataModel = addAddress(toDataModel: dataModel)
        guard let paymentViewController = showPaymentScreen() else { return fail() }
        paymentViewController.paymentCompletion?(.guestRedirect(encryptedCheckoutId: "CHECKOUT_ID", encryptedToken: "TOKEN"))
        _ = AtlasUIViewController.shared?.mainNavigationController.popViewController(animated: true)
    }

}

class GuestSummaryActionHandlerDataSourceDelegateMocked: NSObject, CheckoutSummaryActionHandlerDataSource, CheckoutSummaryActionHandlerDelegate {

    var dataModel: CheckoutSummaryDataModel
    var layout: CheckoutSummaryLayout?

    init(selectedArticleUnit: SelectedArticleUnit) {
        dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit, totalPrice: Money.Zero)
    }

    func updated(dataModel: CheckoutSummaryDataModel) {

    }

    func updated(layout: CheckoutSummaryLayout) {
        self.layout = layout
    }

    func updated(actionHandler: CheckoutSummaryActionHandler) {

    }

    func dismissView() {

    }

}
