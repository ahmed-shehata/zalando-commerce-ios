//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import ZalandoCommerceAPI

class APICartTests: APITestCase {

    func testCreateCart() {
        waitForAPIConfigured { done, api in
            let cartItemRequest = CartItemRequest(sku: SimpleSKU(value: "GU121D08Z-Q1100XL000"), quantity: 1)
            api.createCart(with: [cartItemRequest]) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let cart):
                    expect(cart.id) == self.cartId
                }
                done()
            }
        }
    }

    func testCreateCartWithOutOfStock() {
        waitForAPIConfigured { done, api in
            let cartItemRequest = CartItemRequest(sku: SimpleSKU(value: "EV451G023-Q110ONE000"), quantity: 1)
            api.createCart(with: [cartItemRequest]) { result in
                switch result {
                case .failure(let error, _):
                    switch error {
                    case CheckoutError.outOfStock: done()
                    default: fail("Should be outOfStock error")
                    }
                case .success:
                    fail("Should fail in creating cart with outOfStock Item")
                }
            }
        }
    }

    func testCreateCartWithOutOfStockAndInStockItems() {
        waitForAPIConfigured { done, api in
            let cartItemRequest1 = CartItemRequest(sku: SimpleSKU(value: "GU121D08Z-Q1100XL000"), quantity: 1)
            let cartItemRequest2 = CartItemRequest(sku: SimpleSKU(value: "EV451G023-Q110ONE000"), quantity: 1)
            api.createCart(with: [cartItemRequest1, cartItemRequest2]) { result in
                switch result {
                case .failure(let error, _):
                    switch error {
                    case CheckoutError.outOfStock: done()
                    default: fail("Should be outOfStock error")
                    }
                case .success:
                    fail("Should fail in creating cart with outOfStock Item")
                }
            }
        }
    }

}
