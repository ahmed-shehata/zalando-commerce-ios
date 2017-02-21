//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasSDK

class APIGuestOrderTests: AtlasAPIClientBaseTests {

    func testCreateGuestOrder() {
        waitUntilAtlasAPIClientIsConfigured { done, client in
            let request = GuestOrderRequest(checkoutId: "CHECKOUT_ID", token: "TOKEN")
            client.createGuestOrder(request: request) { result in
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

    func testGuestChecoutPaymentSelectionURL() {
        waitUntilAtlasAPIClientIsConfigured { done, client in
            let request = GuestPaymentSelectionRequest(customer: self.customerRequest, shippingAddress: self.addressRequest, billingAddress: self.addressRequest, cart: self.cartRequest)
            client.guestCheckoutPaymentSelectionURL(request: request) { result in
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
        let variantSKU = VariantSKU(value: "AD541L009-G11000S000")
        let cartItemRequest = CartItemRequest(sku: variantSKU, quantity: 1)
        return GuestCartRequest(items: [cartItemRequest])
    }

    fileprivate var paymentRequest: GuestPaymentRequest {
        return GuestPaymentRequest(method: "PREPAYMENT", metadata: nil)
    }

}
