//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Quick
import Nimble
import AtlasCommons
import AtlasMockAPI

@testable import AtlasSDK

class APIClientSpec: QuickSpec {

    private var atlas: AtlasSDK!

    private let cartId = "CART_ID"
    private let checkoutId = "CHECKOUT_ID"

    override class func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer() // swiftlint:disable:this force_try
    }

    override class func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer() // swiftlint:disable:this force_try
    }

    override func spec() {

        beforeEach {
            let opts = Options(clientId: "clientId", salesChannel: "SALES_CHANNEL", useSandbox: true)
            let configURL = AtlasMockAPI.endpointURL(forPath: "/config")
            self.atlas = AtlasSDK()
            self.atlas.register { ConfigClient(options: opts, endpointURL: configURL) as Configurator }
            self.atlas.setup(opts)
        }

        describe("AtlasAPI") {

            it("should create cart successfully") {
                self.expectStatusToEqualOK()

                let cartItemRequests = [CartItemRequest(sku: "EV451G023-Q110ONE000", quantity: 1)]

                waitUntil(timeout: 10) { done in
                    self.atlas.apiClient?.createCart(cartItemRequests) { result in
                        switch result {
                        case .failure(let error):
                            fail(String(error))
                        case .success(let cart):
                            expect(cart.id).to(equal(self.cartId))
                        }
                        done()
                    }
                }
            }

            it("should create checkout successfully") {
                self.expectStatusToEqualOK()

                waitUntil(timeout: 10) { done in
                    self.atlas.apiClient?.createCheckout(self.cartId) { result in
                        switch result {
                        case .failure(let error):
                            fail(String(error))
                        case .success(let checkout):
                            expect(checkout.id).to(equal(self.checkoutId))
                        }
                        done()
                    }
                }
            }

            it("should create an order successfully") {
                self.expectStatusToEqualOK()

                waitUntil(timeout: 10) { done in
                    self.atlas.apiClient?.createOrder(self.checkoutId) { result in
                        switch result {
                        case .failure(let error):
                            fail(String(error))
                        case .success(let order):
                            expect(order.orderNumber).to(equal("ORDER_NUMBER"))
                        }
                        done()
                    }
                }
            }

        }
    }

    private func expectStatusToEqualOK() {
        expect(self.atlas.status).toEventually(equal(AtlasSDK.Status.ConfigurationOK), timeout: 5)
    }

}
