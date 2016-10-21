//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Quick
import Nimble
import AtlasMockAPI
@testable import AtlasUI
@testable import AtlasSDK

class CheckoutSummaryViewControllerSpec: QuickSpec {

    override class func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer()
    }

    override class func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer()
    }

    override func spec() {
        describe("CheckoutSummaryViewController") {

            it("Should have a valid state") {
                waitUntil(timeout: 10) { done in
                    self.viewController { viewController in

                        var originalViewModel = viewController.checkoutViewModel

                        // Initial state
                        expect(viewController.checkoutViewModel.customer).toNot(beNil())
                        expect(viewController.viewState).to(equal(CheckoutViewState.CheckoutReady))
                        expect(UserMessage.errorDisplayed).to(equal(false))

                        // Change price
                        self.clearState(viewController)
                        viewController.checkoutViewModel.cart = viewController.checkoutViewModel.cart?.cartWithDifferentPrice
                        expect(viewController.checkoutViewModel.customer).toNot(beNil())
                        expect(viewController.viewState).to(equal(CheckoutViewState.CheckoutReady))
                        expect(UserMessage.errorDisplayed).to(equal(true))

                        // Reassign view model after removing the customer
                        self.clearState(viewController)
                        originalViewModel.customer = nil
                        originalViewModel.cart = viewController.checkoutViewModel.cart
                        viewController.checkoutViewModel = originalViewModel
                        expect(viewController.checkoutViewModel.customer).toNot(beNil())
                        expect(viewController.viewState).to(equal(CheckoutViewState.CheckoutReady))
                        expect(UserMessage.errorDisplayed).to(equal(false))

                        // Remove Checkout
                        self.clearState(viewController)
                        viewController.checkoutViewModel.checkout = nil
                        expect(viewController.checkoutViewModel.customer).toNot(beNil())
                        expect(viewController.viewState).to(equal(CheckoutViewState.CheckoutIncomplete))
                        expect(UserMessage.errorDisplayed).to(equal(true))

                        done()
                    }
                }
            }

        }
    }


    private func viewController(completion: (CheckoutSummaryViewController -> Void)) {
        self.atlasCheckout { atlasCheckout in

            atlasCheckout.client.article(forSKU: "AD541L009-G11") { result in
                guard let article = result.process() else { return XCTFail() }
                let selectedArticleUnit = SelectedArticleUnit(article: article, selectedUnitIndex: 0)

                atlasCheckout.createCheckoutViewModel(forArticleUnit: selectedArticleUnit) { result in
                    guard var checkoutViewModel = result.process() else { return XCTFail() }

                    let customer = Customer(customerNumber: "12345678", gender: Customer.Gender.Male,
                        firstName: "John", lastName: "Doe", email: "aaa@a.a")
                    checkoutViewModel.customer = customer

                    let viewController = CheckoutSummaryViewController(checkout: atlasCheckout, checkoutViewModel: checkoutViewModel)
                    self.registerAtlasUIViewController(atlasCheckout)
                    completion(viewController)

                }
            }
        }
    }

    private func atlasCheckout(completion: (AtlasCheckout -> Void)) {
        let configURL = AtlasMockAPI.endpointURL(forPath: "/config")
        let interfaceLanguage = "en"
        let salesChannelId = "82fe2e7f-8c4f-4aa1-9019-b6bde5594456"
        let clientId = "CLIENT_ID"
        let options = Options(clientId: clientId,
                              salesChannel: salesChannelId,
                              interfaceLanguage: interfaceLanguage,
                              configurationURL: configURL)


        AtlasCheckout.configure(options) { result in
            guard let checkout = result.process() else { return XCTFail() }
            Async.main {
                completion(checkout)
            }
        }
    }

    private func registerAtlasUIViewController(checkout: AtlasCheckout) {
        let atlasUIViewController = AtlasUIViewController(atlasCheckout: checkout, forProductSKU: "AD541L009-G11")
        Atlas.register { atlasUIViewController }
    }

    private func clearState(viewController: CheckoutSummaryViewController) {
        viewController.viewState = .CheckoutIncomplete
        let atlasUIViewController: AtlasUIViewController? = try? Atlas.provide()
        atlasUIViewController?.childViewControllers.flatMap { $0 as? BannerErrorViewController }.first?.removeFromParentViewController()
    }

}

private extension Cart {

    var cartWithDifferentPrice: Cart {
        return Cart(id: id,
                    salesChannel: salesChannel,
                    items: items,
                    itemsOutOfStock: itemsOutOfStock,
                    delivery: delivery,
                    grossTotal: Money(amount: 0.01, currency: grossTotal.currency),
                    taxTotal: taxTotal)
    }

}
