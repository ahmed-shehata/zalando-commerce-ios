//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Nimble

@testable import AtlasSDK

class APIOrderSpec: APIClientBaseSpec {

    override func spec() {

        describe("Order") {

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
