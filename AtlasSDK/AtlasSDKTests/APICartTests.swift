//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasSDK

class APICartTests: AtlasAPIClientBaseTests {

    func testCreateCart() {
        waitUntilAtlasAPIClientIsConfigured { done, api in
            let sku = SimpleSKU(value: "EV451G023-Q110ONE000")
            let cartItemRequest = CartItemRequest(sku: sku, quantity: 1)
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

}
