//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct CheckoutViewModel {

    let shippingAddressText: String?
    let paymentMethodText: String?
    let discountText: String?
    let shippingPrice: Article.Price?
    let checkout: Checkout?

    internal(set) var customer: Customer?

    let selectedUnitIndex: Int

    let article: Article

    var isPaymentSelected: Bool {
        return customer != nil && checkout?.payment.selected?.method != nil
    }

    var selectedUnit: Article.Unit {
        return article.units[selectedUnitIndex]
    }

    var unitPrice: Article.Price {
        return self.article.units[selectedUnitIndex].price
    }

    init(article: Article, selectedUnitIndex: Int = 0, shippingPrice: Article.Price? = nil,
        checkout: Checkout? = nil, customer: Customer? = nil,
        shippingAddressText: String? = nil, paymentMethodText: String? = nil, discountText: String? = nil) {
            self.article = article
            self.shippingPrice = shippingPrice
            self.checkout = checkout
            self.customer = customer

            self.shippingAddressText = shippingAddressText ?? checkout?.shippingAddress?.fullAddress()
            self.paymentMethodText = paymentMethodText ?? checkout?.payment.selected?.method
            self.discountText = discountText

            self.selectedUnitIndex = selectedUnitIndex
    }

}
