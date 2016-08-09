//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import AtlasSDK

class APICheckoutSpec: APIClientBaseSpec {

    private let cartId = "CART_ID"
    private let checkoutId = "CHECKOUT_ID"

    override func spec() {

        describe("Checkout API") {

            it("should create cart successfully") {
                self.waitUntilAPIClientIsConfigured { done, client in
                    let cartItemRequest = CartItemRequest(sku: "EV451G023-Q110ONE000", quantity: 1)
                    client.createCart(cartItemRequest) { result in
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
                self.waitUntilAPIClientIsConfigured { done, client in
                    client.createCheckout(self.cartId) { result in
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
                self.waitUntilAPIClientIsConfigured { done, client in
                    client.createOrder(self.checkoutId) { result in
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

}
