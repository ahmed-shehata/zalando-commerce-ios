//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import AtlasSDK

class APICartSpec: APIClientBaseSpec {

    override func spec() {

        describe("Cart") {

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

        }

    }
}
