//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct CheckoutViewModel {

    let selectedArticleUnit: SelectedArticleUnit
    let shippingPrice: Article.Price?
    let cartId: String?
    var checkout: Checkout?
    internal(set) var customer: Customer?

    var selectedBillingAddress: EquatableAddress?
    var selectedShippingAddress: EquatableAddress?

    init(selectedArticleUnit: SelectedArticleUnit,
        shippingPrice: Article.Price? = nil,
        cartId: String? = nil,
        checkout: Checkout? = nil,
        customer: Customer? = nil,
        billingAddress: EquatableAddress? = nil,
        shippingAddress: EquatableAddress? = nil) {
            self.selectedArticleUnit = selectedArticleUnit
            self.shippingPrice = shippingPrice
            self.checkout = checkout
            self.customer = customer
            self.selectedBillingAddress = checkout?.billingAddress
            self.selectedShippingAddress = checkout?.shippingAddress
            self.cartId = cartId

    }

}

extension CheckoutViewModel {

    func shippingAddress(localizedWith localizer: LocalizerProviderType) -> [String] {
        return selectedShippingAddress?.splittedFormattedPostalAddress(localizedWith: localizer) ?? [localizer.loc("No Shipping Address")]
    }

    func billingAddress(localizedWith localizer: LocalizerProviderType) -> [String] {
        return selectedBillingAddress?.splittedFormattedPostalAddress(localizedWith: localizer) ?? [localizer.loc("No Billing Address")]
    }

    var submitButtonTitle: String {
        switch self.checkoutViewState {
        case .NotLoggedIn: return "Zalando.Checkout"
        case .CheckoutIncomplete, .LoggedIn:
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
        return article.units[selectedArticleUnit.selectedUnitIndex]
    }

    var selectedUnitIndex: Int {
        return selectedArticleUnit.selectedUnitIndex
    }

    var article: Article {
        return selectedArticleUnit.article
    }

    var shippingPriceValue: Float {
        return shippingPrice?.amount ?? 0
    }

    var totalPriceValue: Float {
        return shippingPriceValue + selectedUnit.price.amount
    }

    var selectedPaymentMethod: String? {
        return checkout?.payment.selected?.method
    }

    var checkoutViewState: CheckoutViewState {
        if customer == nil {
            return .NotLoggedIn
        }
        return (checkout == nil || checkout?.payment.selected?.method == nil) ? .CheckoutIncomplete : .LoggedIn
    }

}

extension CheckoutViewModel {
    var isReadyToCreateCheckout: Bool? {
        return self.checkout == nil && self.selectedBillingAddress != nil && self.selectedShippingAddress != nil
    }
}
