//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasSDK

class APIOrderTests: APIClientBaseTests {

    func testCreateOrder() {
        waitUntilAPIClientIsConfigured { done, client in
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
