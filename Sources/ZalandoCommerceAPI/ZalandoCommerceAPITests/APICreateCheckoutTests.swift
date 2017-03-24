//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import ZalandoCommerceAPI

class APICreateCheckoutTests: APITestCase {

    func testCreateCheckoutFromArticle() {
        waitForAPIConfigured { done, api in
            let sku = ConfigSKU(value: "AD541L009-G11")
            api.article(with: sku) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let article):
                    let unit = article.units.first { $0.available }!
                    let cartItemRequest = CartItemRequest(sku: unit.id, quantity: 1)
                    api.createCart(with: [cartItemRequest]) { result in
                        switch result {
                        case .failure(let error):
                            fail(String(describing: error))
                        case .success(let result):
                            let request = CreateCheckoutRequest(cartId: result.id)
                            api.createCheckout(request: request) { result in
                                switch result {
                                case .failure(let error):
                                    fail(String(describing: error))
                                case .success(let result):
                                    expect(result.id) == self.checkoutId
                                }
                            done()
                            }
                        }
                    }
                }
            }
        }
    }

    func testCreateCheckoutFromCart() {
        waitForAPIConfigured { done, api in
            let request = CreateCheckoutRequest(cartId: self.cartId)
            api.createCheckout(request: request) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let checkout):
                    expect(checkout.id) == self.checkoutId
                }
                done()
            }
        }
    }

}
