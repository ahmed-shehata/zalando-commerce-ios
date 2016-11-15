//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasSDK

class APIUpdateCheckoutTests: AtlasAPIClientBaseTests {

    private let addressId = "6702759"

    func testUpdateBillingAddress() {
        waitUntilAtlasAPIClientIsConfigured { done, client in
            let updateRequest = UpdateCheckoutRequest(billingAddressId: self.addressId)
            client.updateCheckout(self.checkoutId, updateCheckoutRequest: updateRequest) { result in
                switch result {
                case .failure(let error):
                    fail(String(error))
                case .abortion(let error, _):
                    fail(String(error))
                case .success(let checkout):
                    expect(checkout.id).to(equal(self.checkoutId))
                    expect(checkout.billingAddress.id).to(equal(self.addressId))
                }
                done()
            }
        }
    }

    func testUpdateShippingAddress() {
        waitUntilAtlasAPIClientIsConfigured { done, client in
            let updateRequest = UpdateCheckoutRequest(shippingAddressId: self.addressId)
            client.updateCheckout(self.checkoutId, updateCheckoutRequest: updateRequest) { result in
                switch result {
                case .failure(let error):
                    fail(String(error))
                case .abortion(let error, _):
                    fail(String(error))
                case .success(let checkout):
                    expect(checkout.id).to(equal(self.checkoutId))
                    expect(checkout.shippingAddress.id).to(equal(self.addressId))
                }
                done()
            }
        }
    }

    func testUpdateBillingAndShippingAddresses() {
        waitUntilAtlasAPIClientIsConfigured { done, client in
            let updateRequest = UpdateCheckoutRequest(billingAddressId: self.addressId, shippingAddressId: self.addressId)
            client.updateCheckout(self.checkoutId, updateCheckoutRequest: updateRequest) { result in
                switch result {
                case .failure(let error):
                    fail(String(error))
                case .abortion(let error, _):
                    fail(String(error))
                case .success(let checkout):
                    expect(checkout.id).to(equal(self.checkoutId))
                    expect(checkout.billingAddress.id).to(equal(self.addressId))
                    expect(checkout.shippingAddress.id).to(equal(self.addressId))
                }
                done()
            }
        }
    }

}
