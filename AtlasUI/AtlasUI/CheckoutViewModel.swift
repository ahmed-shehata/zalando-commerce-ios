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

    var selectedBillingAddress: BillingAddress?
    var selectedShippingAddress: ShippingAddress?

    init(selectedArticleUnit: SelectedArticleUnit,
        shippingPrice: Article.Price? = nil,
        cartId: String? = nil,
        checkout: Checkout? = nil,
        customer: Customer? = nil,
        billingAddress: BillingAddress? = nil,
        shippingAddress: ShippingAddress? = nil) {
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

    func shippingAddress(localizedWith localizer: LocalizerProviderType) -> String {
        return selectedShippingAddress?.fullContactPostalAddress ?? localizer.loc("No Shipping Address")
    }

    func billingAddress(localizedWith localizer: LocalizerProviderType) -> String {
        return selectedBillingAddress?.fullContactPostalAddress ?? localizer.loc("No Billing Address")
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
