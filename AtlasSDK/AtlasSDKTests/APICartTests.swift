//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasSDK

class APICartTests: AtlasAPIClientBaseTests {

    func testCreateCart() {
        waitUntilAtlasAPIClientIsConfigured { done, client in
            let variantSKU = VariantSKU(value: "EV451G023-Q110ONE000")
            let cartItemRequest = CartItemRequest(sku: variantSKU, quantity: 1)
            client.createCart(withItems: [cartItemRequest]) { result in
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
