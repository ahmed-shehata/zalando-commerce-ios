//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble
import AtlasMockAPI

@testable import AtlasUI
@testable import AtlasSDK

class CheckoutSummaryViewControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer()
    }

    override func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer()
    }

    func testInitialState() {
        waitUntil(timeout: 10) { done in
            self.viewController { viewController in
                expect(viewController.checkoutViewModel.customer).toNot(beNil())
                expect(viewController.viewState).to(equal(CheckoutViewState.CheckoutReady))
                expect(UserMessage.errorDisplayed).to(equal(false))
                done()
            }
        }
    }

    func testChangePrice() {
        waitUntil(timeout: 10) { done in
            self.viewController { viewController in
                viewController.checkoutViewModel.cart = viewController.checkoutViewModel.cart?.cartWithDifferentPrice
                expect(viewController.checkoutViewModel.customer).toNot(beNil())
                expect(viewController.viewState).to(equal(CheckoutViewState.CheckoutReady))
                expect(UserMessage.errorDisplayed).to(equal(true))
                done()
            }
        }
    }

    func testReassignViewModelAfterRemovingTheCustomer() {
        waitUntil(timeout: 10) { done in
            self.viewController { viewController in
                var checkoutViewModel = viewController.checkoutViewModel
                checkoutViewModel.customer = nil
                viewController.checkoutViewModel = checkoutViewModel
                expect(viewController.checkoutViewModel.customer).toNot(beNil())
                expect(viewController.viewState).to(equal(CheckoutViewState.CheckoutReady))
                expect(UserMessage.errorDisplayed).to(equal(false))
                done()
            }
        }
    }

    func testRemoveCheckout() {
        waitUntil(timeout: 10) { done in
            self.viewController { viewController in
                viewController.checkoutViewModel.checkout = nil
                expect(viewController.checkoutViewModel.customer).toNot(beNil())
                expect(viewController.viewState).to(equal(CheckoutViewState.CheckoutIncomplete))
                expect(UserMessage.errorDisplayed).to(equal(true))
                done()
            }
        }
    }
}

extension CheckoutSummaryViewControllerTests {

    private func viewController(completion: (CheckoutSummaryViewController -> Void)) {
        self.atlasCheckout { atlasCheckout in

            atlasCheckout.client.article("AD541L009-G11") { result in
                guard let article = result.process() else { return XCTFail() }
                let selectedArticleUnit = SelectedArticleUnit(article: article, selectedUnitIndex: 0)

                atlasCheckout.createCheckoutViewModel(selectedArticleUnit) { result in
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
        let options = Options(clientId: "CLIENT_ID",
                              salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                              interfaceLanguage: "en",
                              configurationURL: AtlasMockAPI.endpointURL(forPath: "/config"))

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
