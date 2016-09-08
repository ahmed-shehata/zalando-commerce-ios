//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct CheckoutViewModel {

    let article: Article
    let selectedUnitIndex: Int
    let shippingPrice: Article.Price?
    let cartId: String?
    var checkout: Checkout?
    internal(set) var customer: Customer?

    var selectedBillingAddress: BillingAddress?
    var selectedShippingAddress: ShippingAddress?

    init(article: Article, selectedUnitIndex: Int = 0,
        shippingPrice: Article.Price? = nil,
        cartId: String? = nil,
        checkout: Checkout? = nil,
        customer: Customer? = nil,
        billingAddress: BillingAddress? = nil,
        shippingAddress: ShippingAddress? = nil) {
            self.article = article
            self.selectedUnitIndex = selectedUnitIndex
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
        return article.units[selectedUnitIndex]
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
