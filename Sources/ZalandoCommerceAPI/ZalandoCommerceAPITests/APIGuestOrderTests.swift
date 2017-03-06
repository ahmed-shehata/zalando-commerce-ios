//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import ZalandoCommerceAPI

class APIGuestOrderTests: AtlasAPIClientBaseTests {

    func testCreateGuestOrder() {
        waitUntilAtlasAPIClientIsConfigured { done, api in
            let guestCheckoutId = GuestCheckoutId(checkoutId: "CHECKOUT_ID", token: "TOKEN")
            let request = GuestOrderRequest(guestCheckoutId: guestCheckoutId)
            api.createGuestOrder(request: request) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let order):
                    expect(order.orderNumber) == "10105083300694"
                    expect(order.billingAddress.gender) == Gender.male
                    expect(order.billingAddress.firstName) == "John"
                    expect(order.billingAddress.lastName) == "Doe"
                    expect(order.billingAddress.street) == "Mollstr. 1"
                    expect(order.billingAddress.zip) == "10178"
                    expect(order.billingAddress.city) == "Berlin"
                    expect(order.billingAddress.countryCode) == "DE"
                    expect(order.shippingAddress.gender) == Gender.male
                    expect(order.shippingAddress.firstName) == "John"
                    expect(order.shippingAddress.lastName) == "Doe"
                    expect(order.shippingAddress.street) == "Mollstr. 1"
                    expect(order.shippingAddress.zip) == "10178"
                    expect(order.shippingAddress.city) == "Berlin"
                    expect(order.shippingAddress.countryCode) == "DE"
                    expect(order.grossTotal.amount) == 10.45
                    expect(order.grossTotal.currency) == "EUR"
                    expect(order.taxTotal.amount) == 2.34
                    expect(order.taxTotal.currency) == "EUR"
                }
                done()
            }
        }
    }

    func testGuestCheckoutPaymentSelectionURL() {
        waitUntilAtlasAPIClientIsConfigured { done, api in
            let request = GuestPaymentSelectionRequest(cart: self.cartRequest,
                                                       customer: self.customerRequest,
                                                       shippingAddress: self.addressRequest,
                                                       billingAddress: self.addressRequest)
            api.guestCheckoutPaymentSelectionURL(request: request) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let url):
                    expect(url.absoluteString) == "https://payment-gateway.kohle-integration.zalan.do/payment-method-selection-session/TOKEN/selection"
                }
                done()
            }
        }
    }

}

extension APIGuestOrderTests {

    fileprivate var customerRequest: GuestCustomerRequest {
        return GuestCustomerRequest(email: "john.doe@zalando.de", subscribeNewsletter: false)
    }

    fileprivate var addressRequest: GuestAddressRequest {
        let address = OrderAddress(gender: .male,
                                   firstName: "John",
                                   lastName: "Doe",
                                   street: "Mollstr. 1",
                                   additional: nil,
                                   zip: "10178",
                                   city: "Berlin",
                                   countryCode: "DE",
                                   pickupPoint: nil)
        return GuestAddressRequest(address: address)
    }

    fileprivate var cartRequest: GuestCartRequest {
        let sku = SimpleSKU(value: "AD541L009-G11000S000")
        let cartItemRequest = CartItemRequest(sku: sku, quantity: 1)
        return GuestCartRequest(items: [cartItemRequest])
    }

    fileprivate var paymentRequest: GuestPaymentRequest {
        return GuestPaymentRequest(method: "PREPAYMENT", metadata: nil)
    }

}
