//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Nimble

@testable import AtlasSDK

class APIUpdateCheckoutSpec: APIClientBaseSpec {

    private let addressId = "6702759"

    override func spec() {

        describe("Update checkout") {

            it("should update billing address in checkout successfully") {
                self.waitUntilAPIClientIsConfigured { done, client in
                    let updateRequest = UpdateCheckoutRequest(billingAddressId: self.addressId)
                    client.updateCheckout(self.checkoutId, updateCheckoutRequest: updateRequest) { result in
                        switch result {
                        case .failure(let error):
                            fail(String(error))
                        case .success(let checkout):
                            expect(checkout.id).to(equal(self.checkoutId))
                            expect(checkout.billingAddress.id).to(equal(self.addressId))
                        }
                        done()
                    }
                }
            }

            it("should update shipping address in checkout successfully") {
                self.waitUntilAPIClientIsConfigured { done, client in
                    let updateRequest = UpdateCheckoutRequest(shippingAddressId: self.addressId)
                    client.updateCheckout(self.checkoutId, updateCheckoutRequest: updateRequest) { result in
                        switch result {
                        case .failure(let error):
                            fail(String(error))
                        case .success(let checkout):
                            expect(checkout.id).to(equal(self.checkoutId))
                            expect(checkout.shippingAddress.id).to(equal(self.addressId))
                        }
                        done()
                    }
                }
            }

            it("should update billing and shipping addresses in checkout successfully") {
                self.waitUntilAPIClientIsConfigured { done, client in
                    let updateRequest = UpdateCheckoutRequest(billingAddressId: self.addressId, shippingAddressId: self.addressId)
                    client.updateCheckout(self.checkoutId, updateCheckoutRequest: updateRequest) { result in
                        switch result {
                        case .failure(let error):
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
    }

}
