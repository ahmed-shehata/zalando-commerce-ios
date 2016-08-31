//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct CheckoutViewModel {

    let article: Article
    let selectedUnitIndex: Int
    let shippingPrice: Article.Price?
    let checkout: CheckoutType?
    internal(set) var customer: Customer?

    init(article: Article, selectedUnitIndex: Int = 0, shippingPrice: Article.Price? = nil,
        checkout: CheckoutType? = nil, customer: Customer? = nil) {
            self.article = article
            self.selectedUnitIndex = selectedUnitIndex
            self.shippingPrice = shippingPrice
            self.checkout = checkout
            self.customer = customer
    }

}

extension CheckoutViewModel {

    func shippingAddress(localizedWith localizer: LocalizerProviderType) -> String {
        return checkout?.shippingAddress?.fullAddress ?? localizer.loc("No Shipping Address")
    }

    func billingAddress(localizedWith localizer: LocalizerProviderType) -> String {
        return checkout?.billingAddress?.fullAddress ?? localizer.loc("No Billing Address")
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

}
