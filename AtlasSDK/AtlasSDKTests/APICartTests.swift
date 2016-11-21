//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasSDK

class APICartTests: AtlasAPIClientBaseTests {

    func testCreateCart() {
        waitUntilAtlasAPIClientIsConfigured { done, client in
            let cartItemRequest = CartItemRequest(sku: "EV451G023-Q110ONE000", quantity: 1)
            client.createCart([cartItemRequest]) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let cart):
                    expect(cart.id).to(equal(self.cartId))
                }
                done()
            }
        }
    }

}
