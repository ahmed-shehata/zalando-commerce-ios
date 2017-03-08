//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import ZalandoCommerceAPI

class APIGuestCheckoutTests: APITestCase {

    func testGetGuestCheckout() {
        waitForAPIConfigured { done, api in
            let guestCheckoutId = GuestCheckoutId(checkoutId: "CHECKOUT_ID", token: "TOKEN")
            api.guestCheckout(with: guestCheckoutId) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let guestCheckout):
                    expect(guestCheckout.cart.items[0].sku.value) == "AD541L009-G1100XS000"
                    expect(guestCheckout.cart.items[0].quantity) == 1
                    expect(guestCheckout.cart.grossTotal.amount) == 10.45
                    expect(guestCheckout.cart.grossTotal.currency) == "EUR"
                    expect(guestCheckout.cart.taxTotal.amount) == 2.34
                    expect(guestCheckout.cart.taxTotal.currency) == "EUR"
                    expect(guestCheckout.billingAddress.gender) == Gender.male
                    expect(guestCheckout.billingAddress.firstName) == "John"
                    expect(guestCheckout.billingAddress.lastName) == "Doe"
                    expect(guestCheckout.billingAddress.street) == "Mollstr. 1"
                    expect(guestCheckout.billingAddress.zip) == "10178"
                    expect(guestCheckout.billingAddress.city) == "Berlin"
                    expect(guestCheckout.billingAddress.countryCode) == "DE"
                    expect(guestCheckout.shippingAddress.gender) == Gender.male
                    expect(guestCheckout.shippingAddress.firstName) == "John"
                    expect(guestCheckout.shippingAddress.lastName) == "Doe"
                    expect(guestCheckout.shippingAddress.street) == "Mollstr. 1"
                    expect(guestCheckout.shippingAddress.zip) == "10178"
                    expect(guestCheckout.shippingAddress.city) == "Berlin"
                    expect(guestCheckout.shippingAddress.countryCode) == "DE"
                    expect(guestCheckout.payment.method?.rawValue) == PaymentMethodType.prepayment.rawValue
                }
                done()
            }
        }
    }

}
