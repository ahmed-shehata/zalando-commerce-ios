//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble
import AtlasMockAPI

@testable import AtlasUI
@testable import AtlasSDK

class LoggedInActionHandlerTests: XCTestCase {

    var mockedDelegate: CheckoutSummaryActionHandlerDelegateMock?

    override class func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer()
        Atlas.login("TestToken")
    }

    override class func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer()
        Atlas.logoutUser()
    }

    func testNoPaymentMethodSelected() {
        let actionHandler = createActionHandler()
        actionHandler?.handleSubmitButton()
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testPlaceOrder() {
        let actionHandler = createActionHandler()
        let cartCheckout = createCartCheckout()
        guard let selectedArticleUnit = mockedDelegate?.viewModel.dataModel.selectedArticleUnit else { return fail() }

        let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit, cartCheckout: cartCheckout)
        mockedDelegate?.viewModel.dataModel = dataModel
        actionHandler?.handleSubmitButton()
        expect(self.mockedDelegate?.actionHandler as? OrderPlacedActionHandler).toNotEventually(beNil())
    }

    func testPriceChange() {
        let actionHandler = createActionHandler()
        let cartCheckout = createCartCheckout()
        guard let selectedArticleUnit = mockedDelegate?.viewModel.dataModel.selectedArticleUnit else { return fail() }

        let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit,
                                                 shippingAddress: cartCheckout?.checkout?.shippingAddress,
                                                 billingAddress: cartCheckout?.checkout?.billingAddress,
                                                 paymentMethod: cartCheckout?.checkout?.payment.selected?.method,
                                                 shippingPrice: 0,
                                                 totalPrice: MoneyAmount(string: "0.1"),
                                                 delivery: cartCheckout?.checkout?.delivery)
        mockedDelegate?.viewModel.dataModel = dataModel
        actionHandler?.handleSubmitButton()
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testPaymentMethodRemoved() {
        let _ = createActionHandler()
        guard let selectedArticleUnit = mockedDelegate?.viewModel.dataModel.selectedArticleUnit else { return fail() }

        let dataModel1 = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit,
                                                  shippingAddress: nil,
                                                  billingAddress: nil,
                                                  paymentMethod: "PAYPAL",
                                                  shippingPrice: 0,
                                                  totalPrice: 0,
                                                  delivery: nil)
        let dataModel2 = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit,
                                                  shippingAddress: nil,
                                                  billingAddress: nil,
                                                  paymentMethod: nil,
                                                  shippingPrice: 0,
                                                  totalPrice: 0,
                                                  delivery: nil)
        mockedDelegate?.viewModel.dataModel = dataModel1
        mockedDelegate?.viewModel.dataModel = dataModel2
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testShowingPaymentSelectionScreen() {
        let actionHandler = createActionHandler()
        guard let checkout = actionHandler?.cartCheckout?.checkout else { return fail() }
        actionHandler?.cartCheckout?.checkout = Checkout(id: checkout.id,
                                                         customerNumber: checkout.customerNumber,
                                                         cartId: checkout.cartId,
                                                         delivery: checkout.delivery,
                                                         payment: Payment(selected: nil, isExternalPayment: nil, selectionPageURL: nil),
                                                         billingAddress: checkout.billingAddress,
                                                         shippingAddress: checkout.shippingAddress)
        actionHandler?.showPaymentSelectionScreen()
        expect(UserMessage.errorDisplayed).toEventually(beTrue())

        UserMessage.clearBannerError()
        expect(UserMessage.errorDisplayed).toNotEventually(beTrue())
        actionHandler?.cartCheckout?.checkout = checkout

        guard let selectedArticleUnit = mockedDelegate?.viewModel.dataModel.selectedArticleUnit else { return fail() }
        guard let originalDataModel = mockedDelegate?.viewModel.dataModel else { return fail() }
        let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit,
                                                 shippingAddress: nil,
                                                 billingAddress: nil,
                                                 paymentMethod: nil,
                                                 shippingPrice: 0,
                                                 totalPrice: 0,
                                                 delivery: nil)
        mockedDelegate?.viewModel.dataModel = dataModel
        actionHandler?.showPaymentSelectionScreen()
        expect(UserMessage.errorDisplayed).toEventually(beTrue())

        UserMessage.clearBannerError()
        expect(UserMessage.errorDisplayed).toNotEventually(beTrue())
        mockedDelegate?.viewModel.dataModel = originalDataModel

        actionHandler?.showPaymentSelectionScreen()
        expect(AtlasUIViewController.instance?.mainNavigationController.viewControllers.last as? PaymentViewController).toNotEventually(beNil())
        let paymentViewController = AtlasUIViewController.instance?.mainNavigationController.viewControllers.last as? PaymentViewController

        paymentViewController?.paymentCompletion?(.failure(AtlasCheckoutError.unclassified))
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
        UserMessage.clearBannerError()
        expect(UserMessage.errorDisplayed).toNotEventually(beTrue())


        mockedDelegate?.viewModel.dataModel = dataModel
        paymentViewController?.paymentCompletion?(.success(.success))
        expect(self.mockedDelegate?.viewModel.dataModel.paymentMethod).toNotEventually(beNil())

        paymentViewController?.paymentCompletion?(.success(.error))
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testShowShippingAddressSelectionScreen() {
        let actionHandler = createActionHandler()
        actionHandler?.showShippingAddressSelectionScreen()
        expect(AtlasUIViewController.instance?.mainNavigationController.viewControllers.last as? AddressPickerViewController).toNotEventually(beNil())

        guard let selectedArticleUnit = mockedDelegate?.viewModel.dataModel.selectedArticleUnit else { return fail() }
        let cartCheckout = createCartCheckout()
        let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit, cartCheckout: cartCheckout)
        guard let billingAddress = dataModel.billingAddress as? EquatableAddress else { return fail() }
        mockedDelegate?.viewModel.dataModel = dataModel
        let addressPickerViewController = AtlasUIViewController.instance?.mainNavigationController.viewControllers.last as? AddressPickerViewController

        addressPickerViewController?.addressSelectedHandler?(address: billingAddress)
        expect((self.mockedDelegate?.viewModel.dataModel.shippingAddress as? EquatableAddress)?.id).toEventually(equal(billingAddress.id))
        expect((self.mockedDelegate?.viewModel.dataModel.billingAddress as? EquatableAddress)?.id).toEventually(equal(billingAddress.id))
        expect(UserMessage.errorDisplayed).toNotEventually(beTrue())

        let updatedBillingAddress = CheckoutAddress(id: billingAddress.id,
                                                    gender: billingAddress.gender,
                                                    firstName: "John",
                                                    lastName: "Doe",
                                                    street: billingAddress.street,
                                                    additional: billingAddress.additional,
                                                    zip: billingAddress.zip,
                                                    city: billingAddress.city,
                                                    countryCode: billingAddress.countryCode,
                                                    pickupPoint: billingAddress.pickupPoint)
        expect(self.mockedDelegate?.viewModel.dataModel.shippingAddress?.firstName).to(equal("Erika"))
        expect(self.mockedDelegate?.viewModel.dataModel.billingAddress?.firstName).to(equal("Erika"))
        addressPickerViewController?.addressUpdatedHandler?(address: updatedBillingAddress)
        expect(self.mockedDelegate?.viewModel.dataModel.shippingAddress?.firstName).toEventually(equal("John"))
        expect(self.mockedDelegate?.viewModel.dataModel.billingAddress?.firstName).toEventually(equal("John"))
        expect(UserMessage.errorDisplayed).toNotEventually(beTrue())

        addressPickerViewController?.addressDeletedHandler?(address: billingAddress)
        expect(self.mockedDelegate?.viewModel.dataModel.shippingAddress).toEventually(beNil())
        expect(self.mockedDelegate?.viewModel.dataModel.billingAddress).toEventually(beNil())
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testShowBillingAddressSelectionScreen() {
        let actionHandler = createActionHandler()
        actionHandler?.showBillingAddressSelectionScreen()
        expect(AtlasUIViewController.instance?.mainNavigationController.viewControllers.last as? AddressPickerViewController).toNotEventually(beNil())

        guard let selectedArticleUnit = mockedDelegate?.viewModel.dataModel.selectedArticleUnit else { return fail() }
        let cartCheckout = createCartCheckout()
        let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit, cartCheckout: cartCheckout)
        guard let shippingAddress = dataModel.shippingAddress as? CheckoutAddress else { return fail() }
        mockedDelegate?.viewModel.dataModel = dataModel
        let addressPickerViewController = AtlasUIViewController.instance?.mainNavigationController.viewControllers.last as? AddressPickerViewController

        addressPickerViewController?.addressSelectedHandler?(address: shippingAddress)
        expect((self.mockedDelegate?.viewModel.dataModel.shippingAddress as? EquatableAddress)?.id).toEventually(equal(shippingAddress.id))
        expect((self.mockedDelegate?.viewModel.dataModel.billingAddress as? EquatableAddress)?.id).toEventually(equal(shippingAddress.id))
        expect(UserMessage.errorDisplayed).toNotEventually(beTrue())

        let updatedShippingAddress = CheckoutAddress(id: shippingAddress.id,
                                                     gender: shippingAddress.gender,
                                                     firstName: "John",
                                                     lastName: "Doe",
                                                     street: shippingAddress.street,
                                                     additional: shippingAddress.additional,
                                                     zip: shippingAddress.zip,
                                                     city: shippingAddress.city,
                                                     countryCode: shippingAddress.countryCode,
                                                     pickupPoint: shippingAddress.pickupPoint)
        expect(self.mockedDelegate?.viewModel.dataModel.shippingAddress?.firstName).to(equal("Erika"))
        expect(self.mockedDelegate?.viewModel.dataModel.billingAddress?.firstName).to(equal("Erika"))
        addressPickerViewController?.addressUpdatedHandler?(address: updatedShippingAddress)
        expect(self.mockedDelegate?.viewModel.dataModel.shippingAddress?.firstName).toEventually(equal("John"))
        expect(self.mockedDelegate?.viewModel.dataModel.billingAddress?.firstName).toEventually(equal("John"))
        expect(UserMessage.errorDisplayed).toNotEventually(beTrue())

        addressPickerViewController?.addressDeletedHandler?(address: shippingAddress)
        expect(self.mockedDelegate?.viewModel.dataModel.shippingAddress).toEventually(beNil())
        expect(self.mockedDelegate?.viewModel.dataModel.billingAddress).toEventually(beNil())
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

}

extension LoggedInActionHandlerTests {

    private func createActionHandler() -> LoggedInActionHandler? {
        var loggedInActionHandler: LoggedInActionHandler?
        waitUntil(timeout: 10) { done in
            let sku = "AD541L009-G11"
            self.registerAtlasUIViewController(sku) {
                AtlasUIClient.customer { result in
                    guard let customer = result.process() else { return fail() }
                    AtlasUIClient.article(sku) { result in
                        guard let article = result.process() else { return fail() }
                        let selectedArticleUnit = SelectedArticleUnit(article: article, selectedUnitIndex: 0)
                        LoggedInActionHandler.createInstance(customer, selectedArticleUnit: selectedArticleUnit) { result in
                            guard let actionHandler = result.process() else { return fail() }
                            let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit)
                            self.mockedDelegate = CheckoutSummaryActionHandlerDelegateMock(dataModel: dataModel, actionHandler: actionHandler)
                            actionHandler.delegate = self.mockedDelegate
                            loggedInActionHandler = actionHandler
                            done()
                        }
                    }
                }
            }
        }
        return loggedInActionHandler
    }

    private func createCartCheckout() -> CartCheckout? {
        var cartCheckout: CartCheckout?
        waitUntil(timeout: 10) { done in
            let sku = "AD541L009-G11"
            AtlasUIClient.createCheckoutCart(sku) { result in
                guard let checkoutCart = result.process() else { return fail() }
                cartCheckout = (cart: checkoutCart.cart, checkout: checkoutCart.checkout)
                done()
            }
        }
        return cartCheckout
    }

    private func registerAtlasUIViewController(sku: String, completion: () -> Void) {
        let options = Options(clientId: "CLIENT_ID",
                              salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                              interfaceLanguage: "en",
                              configurationURL: AtlasMockAPI.endpointURL(forPath: "/config"))

        AtlasUI.configure(options) { _ in
            let atlasUIViewController = AtlasUIViewController(forProductSKU: sku)
            let _  = atlasUIViewController.view // load the view
            AtlasUI.register { atlasUIViewController }
            completion()
        }
    }
    
}

class CheckoutSummaryActionHandlerDelegateMock: NSObject, CheckoutSummaryActionHandlerDelegate {

    var viewModel: CheckoutSummaryViewModel
    var actionHandler: CheckoutSummaryActionHandler

    init(dataModel: CheckoutSummaryDataModel, actionHandler: CheckoutSummaryActionHandler) {
        self.viewModel = CheckoutSummaryViewModel(dataModel: dataModel, uiModel: actionHandler.uiModel)
        self.actionHandler = actionHandler
    }

    func dismissView() {}

}
