//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasSDK

class APIGuestCheckoutTests: AtlasAPIClientBaseTests {

    func testGetGuestCheckout() {
        waitUntilAtlasAPIClientIsConfigured { done, client in
            client.guestCheckout(checkoutId: "CHECKOUT_ID", token: "TOKEN") { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let guestCheckout):
                    expect(guestCheckout.cart.items[0].sku).to(equal("AD541L009-G1100XS000"))
                    expect(guestCheckout.cart.items[0].quantity).to(equal(1))
                    expect(guestCheckout.cart.grossTotal.amount).to(equal(10.45))
                    expect(guestCheckout.cart.grossTotal.currency).to(equal("EUR"))
                    expect(guestCheckout.cart.taxTotal.amount).to(equal(2.34))
                    expect(guestCheckout.cart.taxTotal.currency).to(equal("EUR"))
                    expect(guestCheckout.billingAddress.gender).to(equal(Gender.male))
                    expect(guestCheckout.billingAddress.firstName).to(equal("John"))
                    expect(guestCheckout.billingAddress.lastName).to(equal("Doe"))
                    expect(guestCheckout.billingAddress.street).to(equal("Mollstr. 1"))
                    expect(guestCheckout.billingAddress.zip).to(equal("10178"))
                    expect(guestCheckout.billingAddress.city).to(equal("Berlin"))
                    expect(guestCheckout.billingAddress.countryCode).to(equal("DE"))
                    expect(guestCheckout.shippingAddress.gender).to(equal(Gender.male))
                    expect(guestCheckout.shippingAddress.firstName).to(equal("John"))
                    expect(guestCheckout.shippingAddress.lastName).to(equal("Doe"))
                    expect(guestCheckout.shippingAddress.street).to(equal("Mollstr. 1"))
                    expect(guestCheckout.shippingAddress.zip).to(equal("10178"))
                    expect(guestCheckout.shippingAddress.city).to(equal("Berlin"))
                    expect(guestCheckout.shippingAddress.countryCode).to(equal("DE"))
                    expect(guestCheckout.payment.method.rawValue).to(equal("PREPAYMENT"))
                }
                done()
            }
        }
    }

}
