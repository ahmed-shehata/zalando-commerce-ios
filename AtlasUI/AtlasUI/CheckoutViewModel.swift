//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct CheckoutViewModel {

    let selectedArticleUnit: SelectedArticleUnit
    let shippingPrice: Money?
    var cart: Cart?
    var checkout: Checkout?
    internal(set) var customer: Customer?

    var selectedBillingAddress: EquatableAddress?
    var selectedShippingAddress: EquatableAddress?

    var selectedAddresses: CheckoutAddresses {
        return (billingAddress: selectedBillingAddress, shippingAddress: selectedShippingAddress)
    }

    init(selectedArticleUnit: SelectedArticleUnit,
        shippingPrice: Money? = nil,
        cart: Cart? = nil,
        checkout: Checkout? = nil,
        customer: Customer? = nil,
        billingAddress: EquatableAddress? = nil,
        shippingAddress: EquatableAddress? = nil) {
            self.selectedArticleUnit = selectedArticleUnit
            self.shippingPrice = shippingPrice
            self.cart = cart
            self.checkout = checkout
            self.customer = customer
            self.selectedBillingAddress = checkout?.billingAddress
            self.selectedShippingAddress = checkout?.shippingAddress
    }

}

extension CheckoutViewModel {

    var shippingAddress: [String] {
        return selectedShippingAddress?.splittedFormattedPostalAddress ?? [Localizer.string("No Shipping Address")]
    }

    var billingAddress: [String] {
        return selectedBillingAddress?.splittedFormattedPostalAddress ?? [Localizer.string("No Billing Address")]
    }

    var submitButtonTitle: String {
        switch self.checkoutViewState {
        case .NotLoggedIn: return "Zalando.Checkout"
        case .CheckoutIncomplete, .CheckoutReady:
            if let paymentMethod = checkout?.payment.selected where paymentMethod.isPaypal() {
                return "order.place.paypal"
            }
            return "order.place"
        case .OrderPlaced: return "navigation.back.shop"
        }
    }

    var isPaymentSelected: Bool {
        return customer != nil && selectedPaymentMethod != nil
    }

    var selectedUnit: Article.Unit {
        return article.availableUnits[selectedArticleUnit.selectedUnitIndex]
    }

    var selectedUnitIndex: Int {
        return selectedArticleUnit.selectedUnitIndex
    }

    var article: Article {
        return selectedArticleUnit.article
    }

    var shippingPriceValue: MoneyAmount {
        return shippingPrice?.amount ?? 0
    }

    var totalPriceValue: MoneyAmount {
        return cart?.grossTotal.amount ?? 0
    }

    var selectedPaymentMethod: String? {
        return checkout?.payment.selected?.method
    }

    var checkoutViewState: CheckoutViewState {
        if customer == nil {
            return .NotLoggedIn
        }
        return (checkout?.payment.selected?.method == nil) ? .CheckoutIncomplete : .CheckoutReady
    }

}

extension CheckoutViewModel {
    mutating func resetState() {
        self.checkout = nil
        self.selectedBillingAddress = nil
        self.selectedShippingAddress = nil
    }
}

extension CheckoutViewModel {
    var isReadyToCreateCheckout: Bool {
        return self.checkout == nil && self.selectedBillingAddress != nil && self.selectedShippingAddress != nil
    }
}
