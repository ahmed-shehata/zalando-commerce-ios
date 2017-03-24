//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import ZalandoCommerceAPI

class APIOrderTests: APITestCase {

    func testCreateOrder() {
        waitForAPIConfigured { done, api in
            let request = CreateCheckoutRequest(cartId: self.cartId)
            api.createCheckout(request: request) { result in
                guard case .success(let checkout) = result else {
                    return fail("Checkout missing")
                }

                api.createOrder(from: checkout) { result in
                    switch result {
                    case .failure(let error):
                        fail(String(describing: error))
                    case .success(let order):
                        expect(order.orderNumber) == "ORDER_NUMBER"
                    }
                    done()
                }
            }
        }
    }

}
