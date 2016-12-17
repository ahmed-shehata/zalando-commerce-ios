//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasUI
@testable import AtlasSDK

class LoggedInSummaryActionHandlerTests: UITestCase {

    var mockedDataSourceDelegate: CheckoutSummaryActionHandlerDataSourceDelegateMock?
    var actionHandler: LoggedInSummaryActionHandler?

    override func setUp() {
        super.setUp()
        AtlasAPIClient.shared?.authorize(withToken: "TestToken")
        actionHandler = createActionHandler()
    }

    override func tearDown() {
        super.tearDown()
        AtlasAPIClient.shared?.deauthorize()
    }

    func testNoPaymentMethodSelected() {
        actionHandler?.handleSubmit()
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testPlaceOrder() {
        guard let dataModel = createDataModel(fromCartCheckout: createCartCheckout()) else { return fail() }
        mockedDataSourceDelegate?.updated(dataModel: dataModel)
        actionHandler?.handleSubmit()
        expect(self.mockedDataSourceDelegate?.actionHandler as? OrderPlacedSummaryActionHandler).toNotEventually(beNil())
    }

    func testPriceChange() {
        guard let dataModel = createDataModel(fromCheckout: createCartCheckout()?.checkout,
                                              totalPrice: Money(amount: 0.1, currency: "")) else { return fail() }
        mockedDataSourceDelegate?.updated(dataModel: dataModel)
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
        UserMessage.resetBanners()
        actionHandler?.handleSubmit()
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testPaymentMethodRemoved() {
        guard let dataModel1 = createDataModel(withPaymentMethod: "PAYPAL") else { return fail() }
        mockedDataSourceDelegate?.updated(dataModel: dataModel1)
        expect(UserMessage.errorDisplayed).toNotEventually(beTrue())

        guard let dataModel2 = createDataModel(withPaymentMethod: nil) else { return fail() }
        mockedDataSourceDelegate?.updated(dataModel: dataModel2)
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testShowingPaymentSelectionScreenWithEmptyPayment() {
        guard let checkout = actionHandler?.cartCheckout?.checkout else { return fail() }
        actionHandler?.cartCheckout?.checkout = createCheckout(fromCheckout: checkout, payment: Payment(selected: nil, isExternalPayment: nil, selectionPageURL: nil))

        actionHandler?.handlePaymentSelection()
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testShowingPaymentSelectionScreenWithEmptyCartCheckout() {
        actionHandler?.cartCheckout = nil
        actionHandler?.handlePaymentSelection()
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testPaymentScreenCompletionWithError() {
        guard let paymentViewController = presentPaymentScreen() else { return fail() }
        paymentViewController.paymentCompletion?(.error)
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testPaymentScreenCompletionWithSuccess() {
        guard let paymentViewController = presentPaymentScreen() else { return fail() }
        paymentViewController.paymentCompletion?(.success)
        expect(self.mockedDataSourceDelegate?.dataModel.paymentMethod).toNotEventually(beNil())
    }

    func testShippingStandardAddressScreenSelectCompletion() {
        guard let addressViewController = presentAddressScreen(forShippingAddress: true),
            let address = getStandardAddress()
            else { return fail() }

        addressViewController.addressSelectedHandler?(address)
        expect((self.mockedDataSourceDelegate?.dataModel.shippingAddress as? EquatableAddress)?.id).toEventually(equal(address.id))
        expect((self.mockedDataSourceDelegate?.dataModel.billingAddress as? EquatableAddress)?.id).toEventually(equal(address.id))
        expect(UserMessage.errorDisplayed).toNotEventually(beTrue())
    }

    func testShippingPickupPointAddressScreenSelectCompletion() {
        guard let addressViewController = presentAddressScreen(forShippingAddress: true),
            let address = getPickupPointAddress()
            else { return fail() }

        addressViewController.addressSelectedHandler?(address)
        expect((self.mockedDataSourceDelegate?.dataModel.shippingAddress as? EquatableAddress)?.id).toEventually(equal(address.id))
        expect((self.mockedDataSourceDelegate?.dataModel.billingAddress as? EquatableAddress)?.id).toNotEventually(equal(address.id))
        expect(UserMessage.errorDisplayed).toNotEventually(beTrue())
    }

    func testShippingAddressScreenUpdateCompletion() {
        guard let addressViewController = presentAddressScreen(forShippingAddress: true),
            let dataModel = createDataModel(fromCartCheckout: createCartCheckout())
            else { return fail() }
        mockedDataSourceDelegate?.updated(dataModel: dataModel)
        guard let address = self.mockedDataSourceDelegate?.dataModel.shippingAddress as? EquatableAddress else { return fail() }

        expect(self.mockedDataSourceDelegate?.dataModel.shippingAddress?.firstName).to(equal("Erika"))
        expect(self.mockedDataSourceDelegate?.dataModel.billingAddress?.firstName).to(equal("Erika"))
        addressViewController.addressUpdatedHandler?(update(address: address))
        expect(self.mockedDataSourceDelegate?.dataModel.shippingAddress?.firstName).toEventually(equal("John"))
        expect(self.mockedDataSourceDelegate?.dataModel.billingAddress?.firstName).toEventually(equal("Erika"))
        expect(UserMessage.errorDisplayed).toNotEventually(beTrue())
    }

    func testShippingAddressScreenDeleteCompletion() {
        guard let addressViewController = presentAddressScreen(forShippingAddress: true),
            let dataModel = createDataModel(fromCartCheckout: createCartCheckout())
            else { return fail() }
        mockedDataSourceDelegate?.updated(dataModel: dataModel)
        guard let address = self.mockedDataSourceDelegate?.dataModel.shippingAddress as? EquatableAddress else { return fail() }

        addressViewController.addressDeletedHandler?(address)
        expect(self.mockedDataSourceDelegate?.dataModel.shippingAddress).toEventually(beNil())
        expect(self.mockedDataSourceDelegate?.dataModel.billingAddress).toNotEventually(beNil())
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

    func testBillingAddressScreenSelectCompletion() {
        guard let addressViewController = presentAddressScreen(forShippingAddress: false),
            let address = getStandardAddress()
            else { return fail() }

        addressViewController.addressSelectedHandler?(address)
        expect((self.mockedDataSourceDelegate?.dataModel.shippingAddress as? EquatableAddress)?.id).toEventually(equal(address.id))
        expect((self.mockedDataSourceDelegate?.dataModel.billingAddress as? EquatableAddress)?.id).toEventually(equal(address.id))
        expect(UserMessage.errorDisplayed).toNotEventually(beTrue())
    }

    func testBillingAddressScreenUpdateCompletion() {
        guard let addressViewController = presentAddressScreen(forShippingAddress: false),
            let dataModel = createDataModel(fromCartCheckout: createCartCheckout())
            else { return fail() }
        mockedDataSourceDelegate?.updated(dataModel: dataModel)
        guard let address = self.mockedDataSourceDelegate?.dataModel.billingAddress as? EquatableAddress else { return fail() }

        expect(self.mockedDataSourceDelegate?.dataModel.shippingAddress?.firstName).to(equal("Erika"))
        expect(self.mockedDataSourceDelegate?.dataModel.billingAddress?.firstName).to(equal("Erika"))
        addressViewController.addressUpdatedHandler?(update(address: address))
        expect(self.mockedDataSourceDelegate?.dataModel.shippingAddress?.firstName).toEventually(equal("Erika"))
        expect(self.mockedDataSourceDelegate?.dataModel.billingAddress?.firstName).toEventually(equal("John"))
        expect(UserMessage.errorDisplayed).toNotEventually(beTrue())
    }

    func testBillingAddressScreenDeleteCompletion() {
        guard let addressViewController = presentAddressScreen(forShippingAddress: false),
            let dataModel = createDataModel(fromCartCheckout: createCartCheckout())
            else { return fail() }
        mockedDataSourceDelegate?.updated(dataModel: dataModel)
        guard let address = self.mockedDataSourceDelegate?.dataModel.billingAddress as? EquatableAddress else { return fail() }

        addressViewController.addressDeletedHandler?(address)
        expect(self.mockedDataSourceDelegate?.dataModel.shippingAddress).toNotEventually(beNil())
        expect(self.mockedDataSourceDelegate?.dataModel.billingAddress).toEventually(beNil())
        expect(UserMessage.errorDisplayed).toEventually(beTrue())
    }

}

extension LoggedInSummaryActionHandlerTests {

    fileprivate func createActionHandler() -> LoggedInSummaryActionHandler? {
        var loggedInActionHandler: LoggedInSummaryActionHandler?
        waitUntil(timeout: 10) { done in
            let sku = "AD541L009-G11"
            self.registerAtlasUIViewController(forSKU: sku)
            AtlasUIClient.customer { result in
                guard let customer = result.process() else { return fail() }
                AtlasUIClient.article(withSKU: sku) { result in
                    guard let article = result.process() else { return fail() }
                    let selectedArticleUnit = SelectedArticleUnit(article: article, selectedUnitIndex: 0)
                    LoggedInSummaryActionHandler.create(customer: customer, selectedArticleUnit: selectedArticleUnit) { result in
                        guard let actionHandler = result.process() else { return fail() }
                        let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit, totalPrice: selectedArticleUnit.unit.price)
                        let viewModel = CheckoutSummaryViewModel(dataModel: dataModel, layout: LoggedInLayout())
                        self.mockedDataSourceDelegate = CheckoutSummaryActionHandlerDataSourceDelegateMock(viewModel: viewModel)
                        self.mockedDataSourceDelegate?.actionHandler = actionHandler
                        loggedInActionHandler = actionHandler
                        done()
                    }
                }
            }
        }
        return loggedInActionHandler
    }

    fileprivate func createCartCheckout() -> CartCheckout? {
        var cartCheckout: CartCheckout?
        waitUntil(timeout: 10) { done in
            let sku = "AD541L009-G11"
            AtlasUIClient.createCheckoutCart(forSKU: sku) { result in
                guard let checkoutCart = result.process() else { return fail() }
                cartCheckout = (cart: checkoutCart.cart, checkout: checkoutCart.checkout)
                done()
            }
        }
        return cartCheckout
    }

    fileprivate func registerAtlasUIViewController(forSKU sku: String) {
        let atlasUIViewController = AtlasUIViewController(forSKU: sku)
        _ = atlasUIViewController.view // load the view
        try! AtlasUI.shared().register { atlasUIViewController }
    }

    fileprivate func getStandardAddress() -> EquatableAddress? {
        var address: EquatableAddress?
        waitUntil(timeout: 10) { done in
            AtlasUIClient.addresses { result in
                guard let addresses = result.process() else { return fail() }
                address = addresses.filter { !$0.isPickupPoint }.first
                done()
            }
        }
        return address
    }

    fileprivate func getPickupPointAddress() -> EquatableAddress? {
        var address: EquatableAddress?
        waitUntil(timeout: 10) { done in
            AtlasUIClient.addresses { result in
                guard let addresses = result.process() else { return fail() }
                address = addresses.filter { $0.isPickupPoint }.first
                done()
            }
        }
        return address
    }

}

extension LoggedInSummaryActionHandlerTests {

    fileprivate func createDataModel(withPaymentMethod paymentMethod: String?) -> CheckoutSummaryDataModel? {
        guard let selectedArticleUnit = mockedDataSourceDelegate?.dataModel.selectedArticleUnit else { return nil }
        return CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit,
                                        shippingAddress: nil,
                                        billingAddress: nil,
                                        paymentMethod: paymentMethod,
                                        totalPrice: Money(amount: 10.45, currency: "EUR"),
                                        delivery: nil)
    }

    fileprivate func createDataModel(fromCheckout checkout: Checkout?, totalPrice: Money) -> CheckoutSummaryDataModel? {
        guard let selectedArticleUnit = mockedDataSourceDelegate?.dataModel.selectedArticleUnit else { return nil }
        return CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit,
                                        shippingAddress: checkout?.shippingAddress,
                                        billingAddress: checkout?.billingAddress,
                                        paymentMethod: checkout?.payment.selected?.method?.localizedTitle,
                                        totalPrice: totalPrice,
                                        delivery: checkout?.delivery)
    }

    fileprivate func createDataModel(fromCartCheckout cartCheckout: CartCheckout?) -> CheckoutSummaryDataModel? {
        let totalPrice = cartCheckout?.cart?.grossTotal ?? Money.Zero
        return createDataModel(fromCheckout: cartCheckout?.checkout, totalPrice: totalPrice)
    }

    fileprivate func createCheckout(fromCheckout checkout: Checkout, payment: Payment) -> Checkout {
        return Checkout(id: checkout.id,
                        customerNumber: checkout.customerNumber,
                        cartId: checkout.cartId,
                        delivery: checkout.delivery,
                        payment: payment,
                        billingAddress: checkout.billingAddress,
                        shippingAddress: checkout.shippingAddress)
    }

    fileprivate func presentPaymentScreen() -> PaymentViewController? {
        actionHandler?.handlePaymentSelection()
        expect(AtlasUIViewController.shared?.mainNavigationController.viewControllers.last as? PaymentViewController).toNotEventually(beNil())
        return AtlasUIViewController.shared?.mainNavigationController.viewControllers.last as? PaymentViewController
    }

    fileprivate func presentAddressScreen(forShippingAddress isShipping: Bool) -> AddressListViewController? {
        if isShipping {
            actionHandler?.handleShippingAddressSelection()
        } else {
            actionHandler?.handleBillingAddressSelection()
        }
        expect(AtlasUIViewController.shared?.mainNavigationController.viewControllers.last as? AddressListViewController).toNotEventually(beNil())
        return AtlasUIViewController.shared?.mainNavigationController.viewControllers.last as? AddressListViewController
    }

    fileprivate func update(address: EquatableAddress) -> CheckoutAddress {
        return CheckoutAddress(id: address.id,
                               gender: address.gender,
                               firstName: "John",
                               lastName: "Doe",
                               street: address.street,
                               additional: address.additional,
                               zip: address.zip,
                               city: address.city,
                               countryCode: address.countryCode,
                               pickupPoint: address.pickupPoint)
    }

}

class CheckoutSummaryActionHandlerDataSourceDelegateMock: NSObject, CheckoutSummaryActionHandlerDataSource, CheckoutSummaryActionHandlerDelegate {

    var viewModel: CheckoutSummaryViewModel
    var dataModel: CheckoutSummaryDataModel {
        return viewModel.dataModel
    }
    var actionHandler: CheckoutSummaryActionHandler? {
        didSet {
            actionHandler?.dataSource = self
            actionHandler?.delegate = self
        }
    }

    init(viewModel: CheckoutSummaryViewModel) {
        self.viewModel = viewModel
    }

    func updated(dataModel: CheckoutSummaryDataModel) {
        self.viewModel.dataModel = dataModel
    }

    func updated(layout: CheckoutSummaryLayout) {
        self.viewModel.layout = layout
    }

    func updated(actionHandler: CheckoutSummaryActionHandler) {
        self.actionHandler = actionHandler
    }

    func dismissView() {

    }

}
