//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasUI
@testable import AtlasSDK

class LoggedInSummaryActionHandlerTests: UITestCase {

    var mockedDataSourceDelegate: CheckoutSummaryActionHandlerDataSourceDelegateMock?
    var actionHandler: LoggedInSummaryActionHandler?
    var article: Article?

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
        expect(self.errorDisplayed).toEventually(beTrue())
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
        expect(self.errorDisplayed).toEventually(beTrue())
        UserMessage.resetBanners()
        actionHandler?.handleSubmit()
        expect(self.errorDisplayed).toEventually(beTrue())
    }

    func testPaymentMethodRemoved() {
        guard let dataModel1 = createDataModel(withPaymentMethod: "PAYPAL") else { return fail() }
        mockedDataSourceDelegate?.updated(dataModel: dataModel1)
        expect(self.errorDisplayed).toNotEventually(beTrue())

        guard let dataModel2 = createDataModel(withPaymentMethod: nil) else { return fail() }
        mockedDataSourceDelegate?.updated(dataModel: dataModel2)
        expect(self.errorDisplayed).toEventually(beTrue())
    }

    func testShowingPaymentSelectionScreenWithEmptyPayment() {
        guard let checkout = actionHandler?.cartCheckout?.checkout else { return fail() }
        actionHandler?.cartCheckout?.checkout = createCheckout(fromCheckout: checkout, payment: Payment(selected: nil, isExternalPayment: nil, selectionPageURL: nil))

        actionHandler?.handlePaymentSelection()
        expect(self.errorDisplayed).toEventually(beTrue())
    }

    func testShowingPaymentSelectionScreenWithEmptyCartCheckout() {
        actionHandler?.cartCheckout = nil
        actionHandler?.handlePaymentSelection()
        expect(self.errorDisplayed).toEventually(beTrue())
    }

    func testPaymentScreenCompletionWithError() {
        guard let paymentViewController = presentPaymentScreen() else { return fail() }
        paymentViewController.paymentCompletion?(.error)
        expect(self.errorDisplayed).toEventually(beTrue())
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
        expect(self.errorDisplayed).toNotEventually(beTrue())
    }

    func testShippingPickupPointAddressScreenSelectCompletion() {
        guard let addressViewController = presentAddressScreen(forShippingAddress: true),
            let address = getPickupPointAddress()
            else { return fail() }

        addressViewController.addressSelectedHandler?(address)
        expect((self.mockedDataSourceDelegate?.dataModel.shippingAddress as? EquatableAddress)?.id).toEventually(equal(address.id))
        expect((self.mockedDataSourceDelegate?.dataModel.billingAddress as? EquatableAddress)?.id).toNotEventually(equal(address.id))
        expect(self.errorDisplayed).toNotEventually(beTrue())
    }

    func testShippingAddressScreenUpdateCompletion() {
        guard let addressViewController = presentAddressScreen(forShippingAddress: true),
            let dataModel = createDataModel(fromCartCheckout: createCartCheckout())
            else { return fail() }
        mockedDataSourceDelegate?.updated(dataModel: dataModel)
        guard let address = self.mockedDataSourceDelegate?.dataModel.shippingAddress as? EquatableAddress else { return fail() }

        expect(self.mockedDataSourceDelegate?.dataModel.shippingAddress?.firstName) == "Erika"
        expect(self.mockedDataSourceDelegate?.dataModel.billingAddress?.firstName) == "Erika"
        addressViewController.addressUpdatedHandler?(update(address: address))
        expect(self.mockedDataSourceDelegate?.dataModel.shippingAddress?.firstName).toEventually(equal("John"))
        expect(self.mockedDataSourceDelegate?.dataModel.billingAddress?.firstName).toEventually(equal("Erika"))
        expect(self.errorDisplayed).toNotEventually(beTrue())
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
        expect(self.errorDisplayed).toEventually(beTrue())
    }

    func testBillingAddressScreenSelectCompletion() {
        guard let addressViewController = presentAddressScreen(forShippingAddress: false),
            let address = getStandardAddress()
            else { return fail() }

        addressViewController.addressSelectedHandler?(address)
        expect((self.mockedDataSourceDelegate?.dataModel.shippingAddress as? EquatableAddress)?.id).toEventually(equal(address.id))
        expect((self.mockedDataSourceDelegate?.dataModel.billingAddress as? EquatableAddress)?.id).toEventually(equal(address.id))
        expect(self.errorDisplayed).toNotEventually(beTrue())
    }

    func testBillingAddressScreenUpdateCompletion() {
        guard let addressViewController = presentAddressScreen(forShippingAddress: false),
            let dataModel = createDataModel(fromCartCheckout: createCartCheckout())
            else { return fail() }
        mockedDataSourceDelegate?.updated(dataModel: dataModel)
        guard let address = self.mockedDataSourceDelegate?.dataModel.billingAddress as? EquatableAddress else { return fail() }

        expect(self.mockedDataSourceDelegate?.dataModel.shippingAddress?.firstName) == "Erika"
        expect(self.mockedDataSourceDelegate?.dataModel.billingAddress?.firstName) == "Erika"
        addressViewController.addressUpdatedHandler?(update(address: address))
        expect(self.mockedDataSourceDelegate?.dataModel.shippingAddress?.firstName).toEventually(equal("Erika"))
        expect(self.mockedDataSourceDelegate?.dataModel.billingAddress?.firstName).toEventually(equal("John"))
        expect(self.errorDisplayed).toNotEventually(beTrue())
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
        expect(self.errorDisplayed).toEventually(beTrue())
    }

    func testShippingAddressWithNoAddresses() {
        AtlasAPIClient.shared?.authorize(withToken: "TestTokenWithoutAddresses")
        actionHandler?.handleShippingAddressSelection()
        expect(UIApplication.topViewController() as? UIAlertController).toNotEventually(beNil())
        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
    }

    func testBillingAddressWithNoAddresses() {
        AtlasAPIClient.shared?.authorize(withToken: "TestTokenWithoutAddresses")
        actionHandler?.handleBillingAddressSelection()
        expect(UIApplication.topViewController() as? UIAlertController).toNotEventually(beNil())
        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
    }

}

extension LoggedInSummaryActionHandlerTests {

    fileprivate func createActionHandler() -> LoggedInSummaryActionHandler? {
        var loggedInActionHandler: LoggedInSummaryActionHandler?
        waitUntil(timeout: 10) { done in
            AtlasUIClient.customer { result in
                guard let customer = result.process() else { return fail() }
                AtlasUIClient.article(withSKU: self.sku) { result in
                    guard let article = result.process() else { return fail() }
                    self.article = article
                    let selectedArticle = SelectedArticle(article: article, unitIndex: 0, quantity: 1)
                    LoggedInSummaryActionHandler.create(customer: customer, selectedArticle: selectedArticle) { result in
                        guard let actionHandler = result.process() else { return fail() }
                        let dataModel = CheckoutSummaryDataModel(selectedArticle: selectedArticle, totalPrice: selectedArticle.price)
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
        guard let article = article else { return nil }
        var cartCheckout: CartCheckout?
        waitUntil(timeout: 10) { done in
            AtlasUIClient.createCheckoutCart(forSelectedArticle: SelectedArticle(article: article, unitIndex: 0, quantity: 1)) { result in
                guard let checkoutCart = result.process() else { return fail() }
                cartCheckout = (cart: checkoutCart.cart, checkout: checkoutCart.checkout)
                done()
            }
        }
        return cartCheckout
    }

    fileprivate func getStandardAddress() -> EquatableAddress? {
        var address: EquatableAddress?
        waitUntil(timeout: 10) { done in
            AtlasUIClient.addresses { result in
                guard let addresses = result.process() else { return fail() }
                address = addresses.filter { $0.isBillingAllowed }.first
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
                address = addresses.filter { !$0.isBillingAllowed }.first
                done()
            }
        }
        return address
    }

}

extension LoggedInSummaryActionHandlerTests {

    fileprivate func createDataModel(withPaymentMethod paymentMethod: String?) -> CheckoutSummaryDataModel? {
        guard let selectedArticle = mockedDataSourceDelegate?.dataModel.selectedArticle else { return nil }
        return CheckoutSummaryDataModel(selectedArticle: selectedArticle,
                                        shippingAddress: nil,
                                        billingAddress: nil,
                                        paymentMethod: paymentMethod,
                                        totalPrice: Money(amount: 10.45, currency: "EUR"),
                                        delivery: nil)
    }

    fileprivate func createDataModel(fromCheckout checkout: Checkout?, totalPrice: Money) -> CheckoutSummaryDataModel? {
        guard let selectedArticle = mockedDataSourceDelegate?.dataModel.selectedArticle else { return nil }
        return CheckoutSummaryDataModel(selectedArticle: selectedArticle,
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
        expect(self.defaultNavigationController?.viewControllers.last as? PaymentViewController).toNotEventually(beNil())
        return self.defaultNavigationController?.viewControllers.last as? PaymentViewController
    }

    fileprivate func presentAddressScreen(forShippingAddress isShipping: Bool) -> AddressListViewController? {
        if isShipping {
            actionHandler?.handleShippingAddressSelection()
        } else {
            actionHandler?.handleBillingAddressSelection()
        }
        expect(self.defaultNavigationController?.viewControllers.last as? AddressListViewController).toNotEventually(beNil())
        return self.defaultNavigationController?.viewControllers.last as? AddressListViewController
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

    var viewController: CheckoutSummaryViewController
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
        self.viewController = CheckoutSummaryViewController(viewModel: viewModel)
    }

    func updated(dataModel: CheckoutSummaryDataModel) {
        self.viewModel.dataModel = dataModel
        try? viewController.updated(dataModel: dataModel)
    }

    func updated(layout: CheckoutSummaryLayout) {
        self.viewModel.layout = layout
        viewController.updated(layout: layout)
    }

    func updated(actionHandler: CheckoutSummaryActionHandler) {
        self.actionHandler = actionHandler
    }

    func dismissView() {

    }

}
