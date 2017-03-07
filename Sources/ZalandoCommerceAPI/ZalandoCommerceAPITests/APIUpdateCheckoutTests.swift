//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import ZalandoCommerceAPI

class APIUpdateCheckoutTests: APITestCase {

    fileprivate let addressId = "6702759"

    func testUpdateBillingAddress() {
        waitForAPIConfigured { done, api in
            let updateRequest = UpdateCheckoutRequest(billingAddressId: self.addressId)
            api.updateCheckout(with: self.checkoutId, updateCheckoutRequest: updateRequest) { result in
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
        waitForAPIConfigured { done, api in
            let updateRequest = UpdateCheckoutRequest(shippingAddressId: self.addressId)
            api.updateCheckout(with: self.checkoutId, updateCheckoutRequest: updateRequest) { result in
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
        waitForAPIConfigured { done, api in
            let updateRequest = UpdateCheckoutRequest(billingAddressId: self.addressId, shippingAddressId: self.addressId)
            api.updateCheckout(with: self.checkoutId, updateCheckoutRequest: updateRequest) { result in
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
