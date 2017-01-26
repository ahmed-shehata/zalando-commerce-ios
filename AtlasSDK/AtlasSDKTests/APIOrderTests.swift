//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasSDK

class APIOrderTests: AtlasAPIClientBaseTests {

    func testCreateOrder() {
        waitUntilAtlasAPIClientIsConfigured { done, client in
            client.createOrder(fromCheckoutId: self.checkoutId) { result in
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
