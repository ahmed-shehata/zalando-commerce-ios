//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasSDK

class APIUpdateCheckoutTests: AtlasAPIClientBaseTests {

    fileprivate let addressId = "6702759"

    func testUpdateBillingAddress() {
        waitUntilAtlasAPIClientIsConfigured { done, client in
            let updateRequest = UpdateCheckoutRequest(billingAddressId: self.addressId)
            client.updateCheckout(withId: self.checkoutId, updateCheckoutRequest: updateRequest) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let checkout):
                    expect(checkout.id) == self.checkoutId
                    expect(checkout.billingAddress.id) == self.addressId
                }
                done()
            }
        }
    }

    func testUpdateShippingAddress() {
        waitUntilAtlasAPIClientIsConfigured { done, client in
            let updateRequest = UpdateCheckoutRequest(shippingAddressId: self.addressId)
            client.updateCheckout(withId: self.checkoutId, updateCheckoutRequest: updateRequest) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let checkout):
                    expect(checkout.id) == self.checkoutId
                    expect(checkout.shippingAddress.id) == self.addressId
                }
                done()
            }
        }
    }

    func testUpdateBillingAndShippingAddresses() {
        waitUntilAtlasAPIClientIsConfigured { done, client in
            let updateRequest = UpdateCheckoutRequest(billingAddressId: self.addressId, shippingAddressId: self.addressId)
            client.updateCheckout(withId: self.checkoutId, updateCheckoutRequest: updateRequest) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let checkout):
                    expect(checkout.id) == self.checkoutId
                    expect(checkout.billingAddress.id) == self.addressId
                    expect(checkout.shippingAddress.id) == self.addressId
                }
                done()
            }
        }
    }

}
